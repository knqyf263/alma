require 'alma/rpc'

class Alma::RPC::Handler
  def initialize(engine)
    @engine = engine
  end

  def send(target, events)
    @engine.send(target, events)
  end
end
