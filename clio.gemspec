s = Gem::Specification.new do |s|
  s.name         = 'clio-search'
  s.version      = '0.0.1'
  s.date         = '2012-06-24'
  s.summary      = 'API for Columbia Library CLIO Beta'
  s.description  = 'API for Columbia Library CLIO Beta'
  s.authors      = ['Peter Lubell-Doughtie']
  s.email        = 'peter@helioid.com'
  s.files        = ['lib/clio.rb']
  s.homepage     = 'http://www.helioid.com/'
end

s.add_dependency('nokogiri')
s
