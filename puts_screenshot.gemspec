# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'puts_screenshot/version'

Gem::Specification.new do |spec|
  spec.name          = "puts_screenshot"
  spec.version       = PutsScreenshot::VERSION
  spec.authors       = ["Brian Dunn", "Dillon Hafer"]
  spec.email         = ["info@hashrocket.com"]

  spec.summary       = %q{Print a Capybara screenshot in iTerm}
  spec.homepage      = "http://github.com/hashrocket/puts-screenshot"
  spec.license       = "MIT"
  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec)/}) }
  spec.require_paths = ["lib"]

  spec.add_dependency "capybara", "~> 2.3"
  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
