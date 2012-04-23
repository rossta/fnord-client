require 'spec_helper'

describe Fnord::UDPConnection do
  class FakeUDPSocket
    def send(data); end
  end

  let(:connection) {
    Fnord::UDPConnection.new('localhost', 1339)
  }
  let(:socket) { FakeUDPSocket.new }

  describe "send_data" do

    it "should send data to initialized host, port" do
      UDPSocket.should_receive(:new).and_return(socket)
      socket.should_receive(:send).with("data", 0, 'localhost', 1339)
      connection.send_data("data")
    end

  end

end
