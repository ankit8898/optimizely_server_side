$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = 'optimizely_server_side'
  s.version     = '1.0.1'
  s.date        = '2017-04-25'
  s.summary     = "Optimizely server side. A wrapper on top of optimizely's ruby sdk for easy caching of server side config "
  s.description = "Optimizely server side. A A/B test wrapper on top of optimizely's ruby sdk for easy caching of server side config and exposing few more utility helpers. Handling of fallbacks and marking primary experiments. "
  s.authors     = ["Ankit Gupta"]
  s.email       = 'ankit.gupta8898@gmail.com'
  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")

  s.require_paths = ["lib"]
  s.homepage    =
    'https://github.com/ankit8898/optimizely_server_side'
  s.license       = 'MIT'
  s.add_development_dependency 'rspec', '~> 3.5'
  s.add_development_dependency 'webmock', '~> 2.1'
  s.add_runtime_dependency 'optimizely-sdk' , '~> 1.1', '>= 1.1.2'
  s.add_runtime_dependency 'activesupport', '>= 4.2.6'
end
