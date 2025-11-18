require 'sinatra'
require 'webrick'
require 'webrick/https'
require 'openssl'

require_relative 'root.rb'
require_relative 'openid_credential_issuer.rb'
require_relative 'oauth_authrization_server'


set :bind, '0.0.0.0'
set :port, 5000
set :environment, :production

set :server_settings,
  SSLEnable: true,
  SSLVerifyClient: OpenSSL::SSL::VERIFY_NONE,
  SSLCertificate: OpenSSL::X509::Certificate.new(File.open(File.dirname(__FILE__) + '/config_secrets/cert.pem').read),
  SSLPrivateKey: OpenSSL::PKey::RSA.new(File.open(File.dirname(__FILE__) + '/config_secrets/key.pem').read)

get '/' do
  root_reply
end

get '/.well-known/openid-credential-issuer' do
  response_possible_credentials
end

get '/.well-known' do
  response_possible_credentials
end

get '/.well-known/oauth-authorization-server' do
  # redirect "https://oauth-mock.mock.beeceptor.com/oauth/authorize"
  response_oauth_authorization
end
