# encoding: utf-8
$:.push File.expand_path('../lib', __FILE__)

Gem::Specification.new do |gem|
  gem.name        = "fluent-plugin-lookupcsv"
  gem.description = "Lookupcsv plugin for Fluentd"
  gem.homepage    = "https://github.com/yvesbd/fluent-plugin-lookupcsv"
  gem.summary     = gem.description
  gem.version     = File.read("VERSION").strip
  gem.authors     = ["Yves Desharnais"]
  gem.email       = "yvesbd@gmail.com"
  gem.has_rdoc    = false
  #gem.platform    = Gem::Platform::RUBY
  gem.license     = 'Apache License (2.0)'
  gem.files       = `git ls-files`.split("\n")
  gem.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.require_paths = ['lib']

  gem.add_dependency "fluentd", [">= 0.10.17", "< 2"]
  gem.add_dependency "csv", "~> 2.1"
#  gem.add_development_dependency "rake", ">= 0.9.2"
#  gem.add_development_dependency "test-unit", "~> 3.0"
end