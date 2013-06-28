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
  spec.homepage      = "http://support.siclic.fr/projects/bintje"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency('activesupport','>= 3.2.12')
  spec.add_development_dependency "rspec"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end



require 'rake'
Gem::Specification.new do |s|
  s.name        = 'bintje'
  s.version     = '0.1.1'
  s.date        = '2013-06-05'
  s.summary     = "OpenObject Ruby adapter"
  s.description = "Access OpenObject object interface from ruby"
  s.authors     = ["Cedric Brancourt"]
  s.email       = 'cedric.brancourt@gmail.com'
  s.add_dependency('activesupport','>= 3.2.12')
  s.add_development_dependency "rspec"
  s.files       = FileList['lib/**/*.rb'].to_a
  s.homepage    = 'http://lol.com'

end

