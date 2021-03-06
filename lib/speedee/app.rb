require 'rubygems'
require 'sinatra/base'
require 'json'
require 'mail'

class Speedee::App < Sinatra::Base

  set :sessions, true
  set :public_folder, File.expand_path("../public", __FILE__)

  before do
    @db = Notmuch::Database.open(Speedee::Config.get("database", "path"))
  end

  after do
    @db.close if !@db.nil?
  end

  error do
    @db.close if !@db.nil?
  end

  get '/' do
    send_file File.join(settings.public_folder, 'index.html')
  end

  get '/api/tags' do
    tags = []
    begin
      @db.all_tags.each do |t|
        tags << t
      end
    rescue
    end
        
    tags.to_json
  end

  get '/api/searches' do
    searches = Speedee::Config.get_list(/speedee searches\./)
    searches.map do |s|
      val = s.split('=')
      {
        'id' => val[0],
        'search' => val[1]
      }
    end.to_json
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

  get '/api/threads/:id' do
    tags = []
    thread = nil
    query = "thread:#{params[:id]}"

    @db.query(query).search_threads.each do |t|
      t.tags.each do |tag|
        tags << tag
      end

      thread = {
        id: t.thread_id,
        date: t.newest_date,
        tags: tags,
        authors: t.authors.force_encoding("UTF-8"),
        subject: t.subject.force_encoding("UTF-8")
      }
    end

    return thread.to_json
    
  end

  get '/api/threads/:id/messages' do
    query = "thread:#{params[:id]}"

    messages = []
    q = @db.query(query)
    q.sort = Notmuch::SORT_OLDEST_FIRST
    q.search_messages.each do |m|
      messages << format_message(m)
    end
    return messages.to_json
  end

  def format_message(message)
    f = File.open(message.filename, "rb")
    raw = f.read
    f.close

    mail_msg = Mail.new(raw)
    obj = {
      from: message['From'],
      to: message['To'],
      date: message.date,
      body: mail_msg.body.decoded.encode('UTF-8', :replace => '', :invalid => :replace, :undef => :replace).gsub("\n", "<br>"),
      id: message.message_id
    }
    obj
  end
  
end
