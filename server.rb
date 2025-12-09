require 'sinatra'
require 'webrick'
require 'webrick/https'
require 'openssl'
require "json"
require "jwt"
require "base64"
require "securerandom"

require_relative 'root.rb'
require_relative 'issuer_advertisement'
require_relative 'oauth_mock'



set :bind, '0.0.0.0'
set :port, 5000
set :environment, :production
set :logging, true

set :server_settings,
  SSLEnable: true,
  SSLVerifyClient: OpenSSL::SSL::VERIFY_NONE,
  SSLCertificate: OpenSSL::X509::Certificate.new(File.open(File.dirname(__FILE__) + '/config_secrets/cert.pem').read),
  SSLPrivateKey: OpenSSL::PKey::RSA.new(File.open(File.dirname(__FILE__) + '/config_secrets/key.pem').read)

get '/' do
  root_reply
end

get '/.well-known/openid-credential-issuer' do
  content_type :json

  credential_advertisement
end

get '/.well-known/oauth-authorization-server' do
  content_type :json

  oauth_server_advertisement
end

post '/pushed_authorization' do
  content_type :json

  pushed_authorization_mock
end

get '/mock/authorization' do
  logger.info 'Authorization mock callback triggered'
  logger.info "Received state: #{params['state']}"
  logger.info "All params: #{params}"

  redirect url_back_to_wallet_mock(params['state'])
end

post '/mock/token' do
  logger.info "TOKEN REQUEST PARAMS: #{params}"
  logger.info "TOKEN HEADERS: #{request.env.select { |k,_| k.start_with?('HTTP_') }}"

  content_type :json

  access_token_mock
end

# post '/credential' do
#   content_type :json
#   '{
#   "iss": "https://bpissuer.dev:5000",
#   "iat": 1733400000,
#   "exp": 1733400000 + 90*24*60*60,
#   "vct": "urn:eudi:pid:1",
#   "cnf": {
#     "jwk": { /* holder public key bound in the wallet */ }
#   },
#   "family_name": "ExampleFamily",
#   "given_name": "ExampleGiven"
# }
# '
# end

ISSUER = "https://bpissuer.dev"
VCT    = "https://bpissuer.dev"

# Use a stable EC key in real deployment
ISSUER_KEY = OpenSSL::PKey::EC.generate("prime256v1")

helpers do
  def base64url(data)
    Base64.urlsafe_encode64(data).delete("=")
  end

  # Build one disclosure for a claim
  # Returns [disclosure_b64url, digest_b64url]
  def build_disclosure(name, value)
    salt = SecureRandom.urlsafe_base64(16)
    disclosure_array = [salt, name, value]
    json = disclosure_array.to_json

    digest = OpenSSL::Digest::SHA256.digest(json)
    digest_b64 = base64url(digest)
    disclosure_b64 = base64url(json)

    [disclosure_b64, digest_b64]
  end
end

post "/credential" do
  content_type :json

  # request.body.rewind
  body = request.body.read
  req  = JSON.parse(body)
  jwt_proofs = req.dig("proofs", "jwt")

  wallet_keys = []
  jwt_proofs.each do |proof_token|
    payload, header = JWT.decode(proof_token, nil, false)
    jwk = header["jwk"]
    halt 400, { error: "invalid_proof" }.to_json if jwk.nil?
    wallet_keys << jwk
  end

  # 1. Validate access token and authorization details here
  # token = request.env["HTTP_AUTHORIZATION"]&.sub(/^Bearer /, "")
  # halt 401 unless valid_token?(token)

  # 2. Extract or look up subject and wallet public key (JWK)
  # In reality this JWK comes from the proof in the credential request
  # wallet_jwk = {
  #   kty: "EC",
  #   crv: "P-256",
  #   x:   "base64url_x_value",
  #   y:   "base64url_y_value"
  # }

  # 3. Fetch data from your data source for this user
  # Here we hard code an example
  employee_data = {
    "given_name"   => "John",
    "family_name"  => "Doe"
  }

  def issue_sd_jwt(wallet_jwk, employee_data)
  # 4. Build SD JWT payload
    now = Time.now.to_i

    payload = {
      iss: ISSUER,
      iat: now,
      exp: now + 3600 * 24 * 365,
      vct: VCT,
      cnf: { jwk: wallet_jwk },
      employee_id: employee_data["employee_id"],
      employer: employee_data["employer"],
      # _sd: sd_digests
    }

    header = {
      alg: "ES256",
      typ: "vc+sd-jwt"
    }

    # sd_jwt = JWT.encode(payload, ISSUER_KEY, "ES256", header)
    JWT.encode(payload, ISSUER_KEY, "ES256", header)
  end
  # 5. Combine SD JWT plus disclosures into one credential string
  # combined_credential = ([sd_jwt] + disclosures).join("~")

  # 6. Return OID4VCI credential response
  # response_body = {
  #   credentials: [
  #     {
  #       credential: sd_jwt
  #     }
  #   ]
  # }
  #
  # json_response = JSON.pretty_generate(response_body)
  #
  # logger.info json_response
  # json_response
  credentials_array = wallet_keys.map do |wallet_jwk|
    { credential: issue_sd_jwt(wallet_jwk, employee_data) }
  end

  # 6 Return all credentials in one response
  response_body = { credentials: credentials_array }
  JSON.pretty_generate(response_body)
end






# post "/credential" do
#   content_type :json
#
#   request.body.rewind
#   body = request.body.read
#   req  = JSON.parse(body)
#
#   # 1 Check configuration id if needed
#   cfg_id = req["credential_configuration_id"]
#   halt 400, { error: "unknown_credential_configuration" }.to_json \
#     unless cfg_id == "eu.europa.ec.eudi.pid_vc_sd_jwt"
#
#   # 2 Extract all proof JWTs
#   jwt_proofs = req.dig("proofs", "jwt") || []
#   halt 400, { error: "invalid_proof" }.to_json if jwt_proofs.empty?
#
#   # 3 For each proof decode header and get wallet key
#   wallet_keys = []
#
#   jwt_proofs.each do |proof_token|
#     payload, header = JWT.decode(proof_token, nil, false)
#     jwk = header["jwk"]
#     halt 400, { error: "invalid_proof" }.to_json if jwk.nil?
#     wallet_keys << jwk
#   end
#
#   # 4 Fetch subject data once for this user
#   # In real code you derive subject from token or proof
#   employee_data = {
#     "given_name"   => "John",
#     "family_name"  => "Doe",
#     "birthdate"    => "1990-03-12",
#     "employee_id"  => "12345",
#     "employer"     => "Buypass",
#     "role"         => "Engineer"
#   }
#
#   # Helper to issue one SD JWT based credential for one wallet key
#   def issue_sd_jwt(wallet_jwk, employee_data)
#     disclosable = %w[given_name family_name birthdate role]
#     disclosures = []
#     sd_digests  = []
#
#     disclosable.each do |claim|
#       disclosure_b64, digest_b64 = build_disclosure(claim, employee_data[claim])
#       disclosures << disclosure_b64
#       sd_digests  << digest_b64
#     end
#
#     now = Time.now.to_i
#
#     payload = {
#       iss: ISSUER,
#       iat: now,
#       exp: now + 3600 * 24 * 365,
#       vct: VCT,
#       cnf: { jwk: wallet_jwk },
#       employee_id: employee_data["employee_id"],
#       employer: employee_data["employer"],
#       _sd: sd_digests
#     }
#
#     header = {
#       alg: "ES256",
#       typ: "vc+sd-jwt"
#     }
#
#     sd_jwt = JWT.encode(payload, ISSUER_KEY, "ES256", header)
#     ([sd_jwt] + disclosures).join("~")
#   end
#
#   # 5 Build one credential per wallet key
#   credentials_array = wallet_keys.map do |wallet_jwk|
#     { credential: issue_sd_jwt(wallet_jwk, employee_data) }
#   end
#
#   # 6 Return all credentials in one response
#   response_body = { credentials: credentials_array }
#   JSON.pretty_generate(response_body)
# end