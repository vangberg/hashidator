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
  s.files    = [
    "README", 
    "TODO",
		"hashidator.gemspec", 
		"lib/hashidator.rb",
		"lib/hashidator/version.rb"
  ]
  s.test_files  = [
    "test/helper.rb",
    "test/test_hashidator.rb"
  ]
end
