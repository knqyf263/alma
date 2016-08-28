module Alma
  module Alert
    class PerResult
      attr_reader :prev

      def initialize(&bk)
        @prev = Time.at(0)
        define_singleton_method("alert?", &bk)
      end

      def notify?(event)
        alert?(event).tap do |result| 
          @prev =Time.now if result
        end
      end
    end
  end
end
