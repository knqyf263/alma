require 'alma/base'
require 'pathname'

module Alma
  class DSL
    def self.regist_alerts(path)
      base = Base.new

      Dir.glob(path.join('conf.d/*')).each do |file|
        config = File.read file
        base.instance_eval config
      end
      base.alerts
    end
  end
end
