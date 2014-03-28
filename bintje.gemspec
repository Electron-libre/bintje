# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bintje/version'

Gem::Specification.new do |spec|
  spec.name          = "bintje"
  spec.version       = Bintje::VERSION
  spec.authors       = ["Cedric Brancourt"]
  spec.email         = ["cedric.brancourt@gmail.com"]
  spec.description   = %q{OpenObject xmlrpc interface}
  spec.summary       = %q{Access your OpenObject's model from ruby}
  spec.homepage      = "http://github.com/Electron-libre/bintje"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency('activesupport','>= 4.0.0')
  spec.add_development_dependency "rspec", "~> 2.14"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end

