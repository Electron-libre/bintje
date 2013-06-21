require 'rake'
Gem::Specification.new do |s|
  s.name        = 'bintje'
  s.version     = '0.0.3'
  s.date        = '2013-06-05'
  s.summary     = "Openerp Ruby adapter"
  s.description = "Access Openerp object interface from ruby"
  s.authors     = ["Cedric Brancourt"]
  s.email       = 'cedric.brancourt@gmail.com'
  s.add_dependency 'active_support'
  s.add_development_dependency "rspec"
  s.files       = FileList['lib/**/*.rb'].to_a
  s.homepage    = 'http://lol.com'

end