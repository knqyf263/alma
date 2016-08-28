require 'rack/server'
require 'rack/builder'
require 'msgpack-rpc-over-http'

require_relative 'handler'

module Alma::RPC
  class HTTP
    DEFAULT_LISTEN_HOST = '0.0.0.0'
    DEFAULT_LISTEN_PORT = 11235

    DEFAULT_THREADS = 2

    attr_accessor :host, :port, :threads
    attr_accessor :engine, :rack, :thread

    def initialize(opts={})
      @engine = opts[:engine]
      @host = opts[:host] || DEFAULT_LISTEN_HOST
      @port = opts[:port] || DEFAULT_LISTEN_PORT
      @threads = opts[:threads] || DEFAULT_THREADS
      @handler = handler = Alma::RPC::Handler.new(@engine)
      @app = Rack::Builder.new {
        run MessagePack::RPCOverHTTP::Server.app(handler)
      }
    end

    def start
      puts "RPC server #{@host}:#{@port}"
      @thread = Thread.new do
        @rack = Rack::Server.new(
          :app => @app, 
          :Host => @host, :Port => @port, 
          :server => 'webrick'
        )
        @rack.start
      end
    end

    def stop
      @rack.stop
      @thread.kill
      @thread.join
    end

    def shut_off(mode)
      @handler.shut_off(mode)
    end
  end
end
