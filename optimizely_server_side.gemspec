Gem::Specification.new do |s|
  s.name        = 'optimizely_server_side'
  s.version     = '0.0.1'
  s.date        = '2010-04-28'
  s.summary     = "Hola!"
  s.description = "A simple hello world gem"
  s.authors     = ["Nick Quaranto"]
  s.email       = 'ankit.gupta8898@gmail.com'
  s.files       = Dir['lib/*.rb']
  s.homepage    =
    'http://rubygems.org/gems/optimizely_server_side'
  s.license       = 'MIT'
  s.add_development_dependency 'rspec', '~> 3.5'
  s.add_development_dependency 'webmock', '~> 2.1'
  s.add_runtime_dependency 'optimizely-sdk' , '~> 0.1.1'
  s.add_runtime_dependency 'activesupport', '~> 4.2', '>= 4.2.6'
end
