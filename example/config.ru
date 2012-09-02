require 'bundler/setup'
require 'sinatra/base'
require 'omniauth-hackid'

SCOPE = 'email,read_stream'

class App < Sinatra::Base
  # turn off sinatra default X-Frame-Options for FB canvas
  set :protection, :except => :frame_options

  # server-side flow
  get '/' do
    # NOTE: you would just hit this endpoint directly from the browser
    #       in a real app. the redirect is just here to setup the root
    #       path in this example sinatra app.
    redirect '/auth/hackid'
  end

  get '/auth/:provider/callback' do
    content_type 'application/json'
    MultiJson.encode(request.env)
  end

  get '/auth/failure' do
    content_type 'application/json'
    MultiJson.encode(request.env)
  end
end

use Rack::Session::Cookie

use OmniAuth::Builder do
  provider :hackid, ENV['APP_ID'], ENV['APP_SECRET'], :scope => SCOPE
end

run App.new
