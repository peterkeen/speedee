require 'rubygems'
require 'sinatra/base'

class Speedee::App < Sinatra::Base

  set :sessions, true
  set :public_folder, File.expand_path("../public", __FILE__)

  get '/' do
    send_file File.join(settings.public_folder, 'index.html')
  end
  
end
