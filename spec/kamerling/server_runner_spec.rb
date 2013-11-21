require_relative '../spec_helper'

module Kamerling describe ServerRunner do
  describe '#start' do
    let(:http)    { fake { Server::HTTP }                       }
    let(:tcp)     { fake { Server::TCP  }                       }
    let(:udp)     { fake { Server::UDP  }                       }
    let(:http_cl) { fake(as: :class) { Server::HTTP }           }
    let(:tcp_cl)  { fake(as: :class) { Server::TCP  }           }
    let(:udp_cl)  { fake(as: :class) { Server::UDP  }           }
    let(:classes) { { http: http_cl, tcp: tcp_cl, udp: udp_cl } }

    before do
      stub(http_cl).new(addr: Addr['0.0.0.0', 1234, :TCP]) { http }
      stub(tcp_cl).new(addr:  Addr['0.0.0.0', 3456, :TCP]) { tcp  }
      stub(udp_cl).new(addr:  Addr['0.0.0.0', 5678, :UDP]) { udp  }
    end

    it 'starts the servers based on the given command-line parameters' do
      args = %w[--host 0.0.0.0 --http 1234 --tcp 3456 --udp 5678]
      ServerRunner.new(args, classes: classes).start
      http.must_have_received :start, []
      tcp.must_have_received :start,  []
      udp.must_have_received :start,  []
    end

    it 'starts only the servers for which the port was given' do
      args = %w[--host 0.0.0.0 --http 1234]
      ServerRunner.new(args, classes: classes).start
      http.must_have_received :start, []
      tcp.wont_have_received :start,  []
      udp.wont_have_received :start,  []
    end
  end
end end
