require File.expand_path("lib/depict/version", File.dirname(__FILE__))

Gem::Specification.new do |s|
  s.name = %q{depict}
  s.version = Depict::Version::STRING
  s.platform = Gem::Platform::RUBY

  s.authors = ["William Howard"]
  s.email = ["whoward.tke@gmail.com"]
  s.homepage = %q{http://github.com/whoward/depict}

  s.summary = %q{Presentation library with support for multiple bidirectional presentations}

  s.require_paths = ["lib"]

  s.files = Dir.glob("lib/**/*.rb")
  s.test_files = Dir.glob("spec/**/*.rb")

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec", "~> 2.10.0"
  s.add_development_dependency "guard-rspec"
end