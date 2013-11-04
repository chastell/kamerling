require 'sinatra/base'
require 'slim'

module Kamerling class HTTPAPI < Sinatra::Base
  get '/' do
    slim :root
  end
end end
