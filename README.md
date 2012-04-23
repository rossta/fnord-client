# Fnord::Client

Send events to an Fnord server via UDP (or TCP).

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
$fnord.event("message_received", { :user_id => 123 })
# "{\"_type\":\"message_received\",\"user_id\":\"123\"}"

# configure FnordMetric namespace
Fnord::Client.namespace = "staging"
$fnord.event("message_received")
# "{\"_type\":\"message_received\",\"_namespace\":\"staging\"}"
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
