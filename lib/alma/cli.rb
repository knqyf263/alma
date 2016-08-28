require "alma/version"
require 'alma/server'
require 'thor'

module Alma
  class CLI < Thor
    desc "start", "start Alma server process"
    option :host, :type => :string, :default => '0.0.0.0', :aliases => "-H", :desc => 'host address that server listen [0.0.0.0]'
    option :port, :type => :numeric, :default => 11235 , :aliases => "-P", :desc => 'port that server uses [11235]'
    option :path, :type => :string, :default => './', :desc => 'path to directory'

    def start
      conf = {}
      conf[:path] = options[:path]

      server_options = {
        host: options[:host],
        port: options[:port],
      }
      server = Alma::Server.new(server_options, conf)
      server.run
      server.shutdown
    end
  end
end
