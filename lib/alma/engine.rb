module Alma
  class Engine
    attr_reader :targets, :queries, :suspended_queries, :output_pool, :typedef_manager

    def initialize(alerts)
      @alerts = alerts
    end

    def send(target, events)
      return "target not found" unless @alerts.key?(target)
      events.each do |event|
        @alerts[target].each do |alert, notification, opts|
          next if opts[:suppress] and Time.now < alert.prev + opts[:suppress]

          if alert.notify?(event)
            notification.send_all event
          end
        end
      end
      "success"
    end
  end
end
