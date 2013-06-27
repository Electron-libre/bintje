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
