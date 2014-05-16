require_relative '../handler'

module Kamerling module Server class Sock
  attr_reader :addr

  def initialize addr: req(:addr), handler: Handler.new
    @addr    = addr
    @handler = handler
  end

  def join
    thread.join
  end

  def start
    @thread = Thread.new { run_loop }
    wait_till_started
    self
  end

  def stop
    thread.exit.join
  end

  attr_reader :handler, :thread
  private     :handler, :thread

  private

  def handle message, client_addr
    handler.handle message, client_addr
  end
end end end
