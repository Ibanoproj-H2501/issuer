require 'sinatra'
require 'webrick'
require 'webrick/https'
require 'openssl'

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

