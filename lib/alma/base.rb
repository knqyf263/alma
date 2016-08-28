require 'alma/notification'
require 'alma/notification/mail'
require 'alma/alert/per_result'
require 'alma/alert/rolling_time_window'

module Alma
  class Base
    attr_reader :alerts

    def initialize
      @alerts = {}
      @notifications = {}
    end

    def notification(name, &bk)
      n = Alma::Notification.new
      n.instance_exec(&bk)
      @notifications[name] = n
    end

    def configure(target, opts = {}, plugin = nil, &bk)
      begin 
        raise Alma::ConfigError, "'target' is empty." if target.empty?
      rescue
        raise Alma::ConfigError, "'target' must be specifed."
      end

      if plugin.nil? and not block_given?
        raise Alma::ConfigError, "Either block or plugin must be given."
      end

      raise Alma::ConfigError, "plugin must define 'alert?' method." unless plugin.respond_to?(:alert?)
    end

    def per_result(target, opts = {}, plugin=nil, &bk)
      configure(target, opts, plugin, &bk)
      alert_proc = create_alert_proc(plugin, bk)

      p_r = Alma::Alert::PerResult.new(&alert_proc)
      setup_alert p_r, target, opts
    end

    def rolling_time_window(target, opts = {}, &bk)
      configure(target, opts, plugin, &bk)
      alert_proc = create_alert_proc(plugin, bk)
      window = opts.delete(:window)

      rolling = Alma::Alert::RollingTimeWindow.new(window, &bk)
      setup_alert rolling, target, opts
    end

    def setup_alert(alert, target, opts)
      notification = @notifications[opts.delete(:notification)]
      (@alerts[target] ||= []) << [alert, notification, opts]
    end

    def create_alert_proc(plugin, bk)
      plugin.nil? ? bk : Proc.new {|event| plugin.alert? event }
    end
  end
end
