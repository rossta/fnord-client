require 'spec_helper'

describe Fnord::TCPConnection do

  class FakeTCPSocket

    def puts(data)
      @data ||= []
      @data << data
    end

    def flush
      @data = nil
    end

    def close; end
  end

  let(:connection) { Fnord::TCPConnection.new('localhost', 1337) }
  let(:socket) { FakeTCPSocket.new }

  before {
    TCPSocket.stub!(:new).and_return(socket)
    connection.socket = socket
  }

  describe "disconnect" do
    it "closes the socket" do
      socket.should_receive(:close)
      connection.disconnect
    end

    it "removes socket reference" do
      connection.disconnect
      connection.socket.should be_nil
    end
  end

  describe "connected?" do
    it "true if socket exists" do
      connection.socket = socket
      connection.connected?.should be_true
    end

    it "false if socket doesn't exist" do
      connection.socket = nil
      connection.connected?.should be_false
    end
  end

  describe "send_data" do

    it "should puts data and flush over socket" do
      socket.should_receive(:puts).with("data")
      socket.should_receive(:flush)
      connection.send_data("data")
    end

  end
end