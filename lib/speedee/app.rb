require 'rubygems'
require 'sinatra/base'
require 'json'

class Speedee::App < Sinatra::Base

  set :sessions, true
  set :public_folder, File.expand_path("../public", __FILE__)

  before do
    @db = Notmuch::Database.open(File.join(ENV['HOME'], 'mail'))
  end

  after do
    @db.close
  end

  get '/' do
    send_file File.join(settings.public_folder, 'index.html')
  end

  get '/api/threads' do
    query = params[:q] || 'tag:inbox'
    threads = []
    @db.query(query).search_threads.each do |thread|
      tags = []
      thread.tags.each do |tag|
        tags << tag
      end

      threads << {
        id: thread.thread_id,
        date: thread.newest_date,
        tags: tags,
        authors: thread.authors.force_encoding("UTF-8"),
        subject: thread.subject.force_encoding("UTF-8")
      }
    end

    threads.to_json
  end
  
end
