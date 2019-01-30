require 'sinatra'
require 'sinatra/json'
require './lib/storage'
require 'rufus-scheduler'

class App < Sinatra::Base

  #  ===== API =======
  # creating new tracker
  # POST /trackers
  # @params { customer_id: 1, video_id: 2 }
  post '/trackers' do
    tracker = Storage.new(params)
    if tracker.save
      status 201
    else
      status 400
    end
  end

  # getting all trackers
  # GET /trackers
  get '/trackers' do
    Storage.all
  end

  # getting the count of current video streams for the user
  # GET /trackers
  get '/customers/:customer_id/videos' do
    content_type :json
    status 200
    { count: Storage.actual_trackers_by(:customer_id, params[:customer_id]).size }.to_json
  end

  # getting the count of current users who currently watching this video
  # GET /trackers
  get '/videos/:video_id/customers' do
    content_type :json
    status 200
    { count: Storage.actual_trackers_by(:video_id, params[:video_id]).size }.to_json
  end
  # ===================


  # ====== The cron for cleaning old trackers
  scheduler_thread = Thread.new do

    scheduler = Rufus::Scheduler.new

    scheduler.every '10s' do
      Storage.delete_expired_records
    end

    scheduler.join

  end
  # =======

end
