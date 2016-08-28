require 'msgpack-rpc-over-http'

module Alma::RPC
  class ClientError < MessagePack::RPCOverHTTP::RemoteError; end
  class ServerError < MessagePack::RPCOverHTTP::RemoteError; end
  class ServiceUnavailableError < MessagePack::RPCOverHTTP::RemoteError; end
end

require 'alma/rpc/handler'
require 'alma/rpc/http'
