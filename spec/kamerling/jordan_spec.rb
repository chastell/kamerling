# encoding: UTF-8

require_relative '../spec_helper'

require 'em-ventually'
require 'socket'

module Kamerling describe Jordan do
  include EM::Ventually

  def with_jordan opts = {}
    EM.run { yield Jordan.new opts }
  end

  describe '.new' do
    it 'starts the server on the given host and port' do
      with_jordan host: '0.0.0.0', port: 1981 do |jordan|
        eventually { TCPSocket.new('0.0.0.0', 1981).close.nil? }
      end
    end
  end

  describe '#host' do
    it 'returns the server’s host (127.0.0.1 by default)' do
      with_jordan do |jordan|
        eventually { jordan.host == '127.0.0.1' }
      end
    end
  end

  describe '#port' do
    it 'returns the server’s port (random available by default)' do
      with_jordan do |jordan|
        eventually { (1024..65535).include? jordan.port }
      end
    end
  end
end end
