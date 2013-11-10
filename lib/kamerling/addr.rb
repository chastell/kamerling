module Kamerling
  Addr = Struct.new :host, :port, :prot do
    def connectable?
      TCPSocket.open(*self).close
      true
    rescue Errno::ECONNREFUSED
      false
    end

    def to_a
      [host, port]
    end

    def to_s
      "#{host}:#{port} (#{prot})"
    end
  end
end
