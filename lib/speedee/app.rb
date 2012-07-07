require 'rubygems'
require 'sinatra/base'
require 'json'
require 'mail'

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
    @db.query(query).search_threads.each do |t|

      t.toplevel_messages.each do |message|
        messages += flatten_replies(message)
      end
    end
    return messages.to_json
  end

  def flatten_replies(root_message)
    puts root_message.message_id
    msgs = [format_message(root_message)]
    begin
        root_message.replies.each do |message|
        puts message.message_id
        msgs += flatten_replies(message)
      end
    rescue RuntimeError
    end
    msgs
  end

  def format_message(message)
    raw = File.read(message.filename).encode('UTF-8', invalid: :replace, :undef => :replace, replace: '')
    mail_msg = Mail.new(raw)
    {
      from: message['From'],
      to: message['To'],
      date: message.date,
      body: mail_msg.body.to_s.gsub("\n", "<br>").encode('UTF-8', invalid: :replace, :undef => :replace, replace: ''),
      id: message.message_id
    }
  end
  
end
