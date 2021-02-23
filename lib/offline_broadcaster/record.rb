# OfflineBroadcaster::Record schema
# receiver (polymorphic)
# channel  (string)
# data     (json)

module OfflineBroadcaster
  class Record < ActiveRecord::Base
    belongs_to :receiver, polymorphic: true
  end

  def self.table_name_prefix
    'offline_broadcaster_'
  end
end
