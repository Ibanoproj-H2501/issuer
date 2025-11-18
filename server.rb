require 'sinatra'
require 'webrick'
require 'webrick/https'
require 'openssl'

require_relative 'root.rb'
require_relative 'openid_credential_issuer.rb'


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
