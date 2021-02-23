module OfflineBroadcaster

  class Adapter
    # Delivers the `data` to receiver if it is online,
    #   else save into DB.
    def self.deliver(channel:, receiver:, data:)
      config = receiver.offline_broadcaster_config
      if receiver.send(config.online_attribute)
        config.adapter.collect(channel: channel, receiver: receiver, data: data)
        return
      end
      Record.create!(channel: channel, receiver: receiver, data: data)
    end

    # Should be overloaded by specified adapter,
    #   So we can customize behaviour on delivering the `data`.
    def self.collect(channel:, receiver:, data:)
      raise NotImplementedError
    end
  end
end
