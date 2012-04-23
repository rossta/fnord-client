# -*- encoding: utf-8 -*-
require File.expand_path('../lib/fnord/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Ross Kaffenberger"]
  gem.email         = ["rosskaff@gmail.com"]
  gem.description   = %q{A client for sending events to an FnordMetric server over UDP (or TCP)}
  gem.summary       = %q{A client for sending events to an FnordMetric server over UDP (or TCP)}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(spec)/})
  gem.name          = "fnord-client"
  gem.require_paths = ["lib"]
  gem.version       = Fnord::VERSION

  gem.add_dependency "yajl-ruby"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec"
end
