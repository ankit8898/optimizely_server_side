Gem::Specification.new do |s|
  s.name        = 'optimizely_config_provider'
  s.version     = '0.0.1'
  s.date        = '2010-04-28'
  s.summary     = "Hola!"
  s.description = "A simple hello world gem"
  s.authors     = ["Nick Quaranto"]
  s.email       = 'nick@quaran.to'
  s.files       = ["lib/hola.rb"]
  s.homepage    =
    'http://rubygems.org/gems/hola'
  s.license       = 'MIT'
  s.add_development_dependency 'rspec', '~> 3.5'
  s.add_development_dependency 'webmock'
  s.add_runtime_dependency 'optimizely-sdk'
  s.add_runtime_dependency 'activesupport', '~> 4.2', '>= 4.2.6'
end
