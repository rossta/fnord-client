# Fnord::Client

Send events to an [FnordMetric](https://github.com/paulasmuth/fnordmetric) server via UDP (or TCP).

[![Build Status](https://secure.travis-ci.org/rossta/fnord-client.png?branch=master)](http://travis-ci.org/rossta/fnord-client)

## Installation

Add this line to your application's Gemfile:

    gem 'fnord-client'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fnord-client

## Usage

```ruby
# Connect to FnordMetric inbound stream over UDP (default)
$fnord = Fnord::Client('localhost', 1337)

# Connect to FnordMetric inbound stream over TCP
$fnord = Fnord::Client('localhost', 1337, :protocol => :tcp)

# send JSON-encoded event
$fnord.event("message_received", :user_id => 123)
# "{\"_type\":\"message_received\",\"user_id\":\"123\"}"

# set a default namespace
Fnord::Client.namespace = "staging"
$fnord.event("message_received")
# "{\"_type\":\"message_received\",\"_namespace\":\"staging\"}"

# on the server-side, configure FnordMetric to listen over UDP
FnordMetric.server_configuration = {
  :inbound_protocol => :udp,
  :inbound_stream => ['0.0.0.0', '1337']
  # other options omitted
}
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
