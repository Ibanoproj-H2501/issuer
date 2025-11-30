require 'cgi'
require 'securerandom'
require 'json'

def pushed_authorization_mock
  response_body = {
    expires_in: 3600,
    request_uri: 'urn:uuid:89bf96c2-767e-4664-90ee-b46e7394cdf8'
  }

  response_body.to_json
end

def url_back_to_wallet_mock(state)
  code = SecureRandom.urlsafe_base64(32)

  redirect_params = {
    'state' => state,
    'code' => code,
    'iss' => 'https://bpissuer.dev:5000/mock',
    'client_id' => 'wallet-dev'
  }
  query_string = redirect_params.map { |k, v| "#{k}=#{CGI.escape(v)}" }.join('&')
  "eu.europa.ec.euidi://authorization?#{query_string}"
end

def access_token_mock
  access_token  = SecureRandom.urlsafe_base64(64)
  refresh_token = SecureRandom.urlsafe_base64(64)

  response_body = {
    access_token:  access_token,
    expires_in:    3600,
    refresh_token: refresh_token,
    scope:         'eu.europa.ec.eudi.pid_vc_sd_jwt',
    token_type:    'DPoP'
  }

  response_body.to_json
end
