module Alma
  module Alert
    class RollingTimeWindow
      attr_reader :prev

      def initialize(window, &bk)
        @events = []
        @prev = Time.at(0)
        @window = window
        define_singleton_method("alert?", &bk)
      end

      def notify?(event)
        now = Time.now
        @events << [now, event]
        @events = @events.drop_while {|time, event| time < now - @window }
        alert?(@events).tap do |result| 
          @prev = now if result
        end
      end
    end
  end
end
