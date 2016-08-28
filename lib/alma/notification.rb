module Alma
  class Notification
    attr_reader :mails, :slacks

    def initialize
      @mails = {}
      @slacks = {}
    end

    def mail(name, &bk)
      m = Alma::Notification::Mail.new
      m.instance_exec(&bk)
      m.configure
      @mails[name] = m
    end

    def slack(name, &bk)
      m = Alma::Notification::Slack.new
      m.instance_exec(&bk)
      @slacks[name] = m
    end

    def send_all(event)
      instance_variables.map do |var| 
        instance_variable_get(var).each_value {|n| n.send(event) }
      end
    end
  end
end
