class Storage

  @@records = []

  class << self

    def trackers_by(attribute, value)
      @@records.select { |record| record[attribute] == value }
    end

    def actual_records(records)
      current_time = Time.now
      records.select { |record| record[:created_at] > current_time - 50 }
    end

    def actual_trackers_by(attribute, value)
      trackers = self.trackers_by(attribute, value)
      self.actual_records(trackers)
    end

    def get_all_by_video(video_id)
      @@records.select { |record| record[:video_id ]== video_id }
    end

    def delete_expired_records
      current_time = Time.now
      @@records.delete_if { |record| record[:created_at] < current_time - 50 }
    end

    def all
      @@records
    end

  end

  def initialize(attributes)
    @customer_id, @video_id = attributes[:customer_id], attributes[:video_id]
  end

  def save
    if valid?
      attributes = { customer_id: @customer_id, video_id: @video_id, created_at: Time.now }
      @@records << attributes
      true
    else
      false
    end
  end

  def valid?
    @customer_id && @customer_id
  end

end