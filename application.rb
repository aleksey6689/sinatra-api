# gems
require 'sinatra'
require 'sinatra/json'
require 'rufus-scheduler'
require 'redis'

# application
require './lib/storage'

class App < Sinatra::Base

  # Store settings
  set :store_adapter, :ruby # store adapter, available: [:ruby, :redis]

  # Application settings
  set :cron_frequency, '10s' # available values type s, h, d (example: '3h10m')
  set :expires_at, 6         # the time period when a record will be actual

  puts 'settings:', {
      store: settings.store_adapter,
      expires_at: settings.expires_at,
      cron_frequency: settings.cron_frequency
  }

  @@store = Storage.new(settings.expires_at, settings.store_adapter)

  #  ===== API =======
  # creating new tracker
  # POST /trackers
  # @params { customer_id: 1, video_id: 2 }
  post '/trackers' do
    if @@store.add({ 'customer_id' => params[:customer_id], 'video_id' => params[:video_id] })
      status 201
    else
      status 400
    end
  end

  # getting all trackers
  # GET /trackers
  get '/trackers' do
    content_type :json
    @@store.records.to_json()
  end

  # getting the count of current video streams for the user
  # GET /trackers
  get '/customers/:customer_id/videos' do
    content_type :json
    status 200
    { count: @@store.actual_trackers_by(:customer_id, params[:customer_id]).size }.to_json
  end

  # getting the count of current users who currently watching this video
  # GET /trackers
  get '/videos/:video_id/customers' do
    content_type :json
    status 200
    { count: @@store.actual_trackers_by(:video_id, params[:video_id]).size }.to_json
  end
  # ===================


  # ====== The cron for cleaning expired records
  unless @@store.adapter_redis?
    Thread.new do
      scheduler = Rufus::Scheduler.new
      scheduler.every settings.cron_frequency do
        @@store.delete_expired_records
      end
      scheduler.join
    end
  end
  # =======

end
