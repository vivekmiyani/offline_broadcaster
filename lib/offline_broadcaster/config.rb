module OfflineBroadcaster

  Config = Struct.new :model, :online_attribute, :adapter, keyword_init: true do
    # Enters into callback if user is online
    #   hence, we need to deliver pending records.
    def setup_callbacks
      model.before_save if: -> { send("#{offline_broadcaster_config.online_attribute}_changed?") && send(offline_broadcaster_config.online_attribute) } do
        adapter = offline_broadcaster_config.adapter
        self.offline_broadcaster_records.in_batches do |records|
          records.each do |record|
            adapter.collect(channel: record.channel, receiver: record.receiver, data: record.data)
          end
          records.destroy_all
        end
      end
    end
  end

  module ClassMethods

    def acts_as_offline_receiver(online_attribute:, adapter:)
      class_attribute :offline_broadcaster_config
      self.offline_broadcaster_config = Config.new(model: self, online_attribute: online_attribute, adapter: adapter)

      has_many :offline_broadcaster_records, class_name: 'OfflineBroadcaster::Record', as: :receiver, dependent: :destroy

      self.offline_broadcaster_config.setup_callbacks
    end
  end
end
