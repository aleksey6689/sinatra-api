class Storage

  def initialize(expires_at = 6, adapter = :ruby)
    @adapter = adapter
    @expires_at = expires_at
    @records = []
    if adapter_redis?
      @redis_store = Redis.new
    end
  end

  def records
    if adapter_redis?
      @records = []
      @redis_store.scan_each(match: 'storage:*') do |key|
        @records << JSON.parse(@redis_store.get(key)).to_h
      end
    end
    @records
  end

  def add(attributes)
    attributes['created_at'] = Time.now.to_i
    if adapter_redis?
      @redis_store.set(
        "storage:customer#{attributes['customer_id']}:#{attributes['created_at']}",
        attributes.to_json,
        ex: @expires_at
      )
    else
      @records << attributes
    end
  end

  def trackers_by(attribute, value)
    records.select do |record|
      record[attribute.to_s] == value
    end
  end

  def actual_records(trackers)
    unix_current_time = Time.now.to_i
    puts 'actual_records', trackers
    trackers.select do |record|
      record['created_at'] > unix_current_time - @expires_at
    end
  end

  def actual_trackers_by(attribute, value)
    trackers = trackers_by(attribute, value)
    actual_records(trackers)
  end

  def delete_expired_records
    unix_current_time = Time.now.to_i
    records.delete_if { |record| record['created_at'] < unix_current_time - @expires_at }
  end

  def adapter_redis?
    @adapter == :redis
  end

end