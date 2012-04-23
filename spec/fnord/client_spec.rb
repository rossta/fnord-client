require 'spec_helper'
require 'json'

describe Fnord::Client do
  let(:client) { Fnord::Client.new('localhost', 1339) }
  let(:connection) { stub(Fnord::UDPConnection) }

  describe "initialize" do
    before { Fnord::Client.namespace = "clientapp_test" }
    it { Fnord::Client.namespace.should == "clientapp_test" }
    it { client.host.should == 'localhost' }
    it { client.port.should == 1339 }
  end

  describe "event" do
    before { client.connection = connection }

    it "should send hash as json via connection" do
      data = { "one" => "1" }
      connection.should_receive(:send_data).with(/#{%Q|"one":"1"|}/)
      client.event(data)
    end

    it "should merge global namespace" do
      data = { "one" => "1" }
      connection.should_receive(:send_data).with(/#{%Q|"_namespace":"clientapp_test\"|}/)
      client.event(data)
    end

    it "should merge given namespace over global" do
      data = { "one" => "1", "_namespace" => "custom_namespace" }
      connection.should_receive(:send_data).with(/#{%Q|"_namespace":"custom_namespace\"|}/)
      client.event(data)
    end

    it "should send numeric values as strings" do
      data = { "one" => 1 }
      connection.should_receive(:send_data).with(/#{%Q|"one":"1"|}/)
      client.event(data)
    end

    it "should merge event type when given as first arg" do
      data = { "one" => "1", "two" => 2 }
      connection.should_receive(:send_data).with(/#{%Q|"_type":"logged_in"|}/)
      client.event("logged_in", data)
    end

    it "should be parseable as JSON" do
      data = { "one" => "1", "two" => 2 }
      connection.should_receive(:send_data) do |msg|
        json = JSON.parse(msg)
        json["one"].should == "1"
        json["two"].should == "2"
        json["_type"].should == "logged_in"
        json["_namespace"].should == "clientapp_test"
      end
      client.event("logged_in", data)
    end
  end

  describe "connection" do
    it "connects uses UDP strategy by default" do
      client.connection.should be_kind_of(Fnord::UDPConnection)
    end

    it "connects set TCP strategy via option" do
      client = Fnord::Client.new('localhost', 1337, :protocol => :tcp)
      client.connection.should be_kind_of(Fnord::TCPConnection)
    end
  end
end