require 'sinatra'
require_relative 'root.rb'

configure do
  set :environment, :production
end

get '/' do
  root_reply
end

get '/.well-known/openid-credential-issuer' do
  "credential endpoint"
end