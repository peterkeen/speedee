require 'rubygems'
require 'sinatra/base'
require 'json'

class Speedee::App < Sinatra::Base

  set :sessions, true
  set :public_folder, File.expand_path("../public", __FILE__)

  get '/' do
    send_file File.join(settings.public_folder, 'index.html')
  end


  get '/api/threads' do
    [
      {id: 0, authors: "Pete, Mark, Sarah", subject: "Movie Night", date: "2012/01/01"},
      {id: 1, authors: "Pete, Mark, Sarah", subject: "Movie Night", date: "2012/02/02"},
      {id: 2, authors: "Pete, Mark, Sarah", subject: "Movie Night", date: "2012/03/03"},
      {id: 3, authors: "Pete, Mark, Sarah", subject: "Movie Night", date: "2012/04/04"},
    ].to_json
  end
  
end
