require 'sinatra'
require 'webrick/https'
require 'openssl'

require_relative 'root.rb'
require_relative 'openid_credential_issuer.rb'


set :bind, '0.0.0.0'
set :environment, :production

get '/' do
  root_reply
end

get '/.well-known/openid-credential-issuer' do
  response_possible_credentials
end
