# frozen_string_literal: true

require_relative 'offline_broadcaster/version'
require_relative 'offline_broadcaster/adapter'
require_relative 'offline_broadcaster/config'
require_relative 'offline_broadcaster/record'

module OfflineBroadcaster
  class Error < StandardError; end
end

ActiveSupport.on_load(:active_record) do
  extend OfflineBroadcaster::ClassMethods
end
