# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'moniker/api/version'

Gem::Specification.new do |spec|
  spec.name          = "moniker-api"
  spec.version       = Moniker::Api::VERSION
  spec.authors       = ["Jonathan Siegel"]
  spec.email         = ["jonathan@siegel.io"]
  spec.description   = %q{Integrates with Moniker.com's API. Yep. They have one.}
  spec.summary       = %q{Contact your Moniker rep to get access.}
  spec.homepage      = "http://jsiegel.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "nokogiri"
  spec.add_development_dependency "open-uri"
  spec.add_development_dependency "net/ssh"
  spec.add_development_dependency "escape"
end
