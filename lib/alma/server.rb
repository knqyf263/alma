 require 'alma/engine'
 require 'alma/dsl'
 require 'alma/rpc/http'

module Alma
  class Server
    def initialize(server_options, conf)
      alma_home = Pathname.new File.expand_path(conf[:path])

      load_plugin(alma_home)

      alerts = Alma::DSL.regist_alerts alma_home
			@engine = Alma::Engine.new(alerts)
      @rpcserver = Alma::RPC::HTTP.new(
        engine: @engine,
				host: server_options[:host],
				port: server_options[:port]
			)
    end

    def load_plugin(path)
      Dir.glob(path.join("plugin/*.rb")).each do |file|
        require file
      end
    end

    def run
      @rpcserver.start
      loop do
        sleep 1
      end
    end

    def shutdown
      @rpcserver.stop
    end
  end
end
