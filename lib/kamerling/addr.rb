module Kamerling
  Addr = Struct.new :host, :port, :prot do
    def to_a
      [host, port]
    end
  end
end
