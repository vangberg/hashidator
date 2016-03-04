$:.push File.expand_path("../lib", __FILE__)
require 'hashidator/version'

Gem::Specification.new do |s|
  s.name     = "hashidator"
  s.version  = Hashidator::VERSION
  s.summary  = "define schemas as a hash, and validate hashes!"
  s.email    = "harry@vangberg.name"
  s.homepage = "https://github.com/vangberg/hashidator"
  s.description = "define schemas as a hash, and validate hashes!"
  s.has_rdoc = false
  s.authors  = ["Harry Vangberg", "Peter Suschlik"]

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency 'rake', '~> 10.5.0'
  s.add_development_dependency 'minitest', '~> 5.8.4'
end
