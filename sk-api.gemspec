# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'version'
Gem::Specification.new do |s|
  s.name = %q{sk-api}
  s.version = SKApi::VERSION
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Georg Leciejewski"]
  s.date = %q{2010-11-07}
  s.description = %q{Interact with SalesKing}
  s.email = %q{gl@salesking.eu}
  s.extra_rdoc_files = [
    "README.rdoc"
  ]

  s.homepage = %q{http://github.com/salesking/sk-api}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Interact with SalesKing}
  s.executables   = nil
  s.files         = `git ls-files`.split("\n").reject{|i| i[/^docs\//] }
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")

  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.2}

  s.add_runtime_dependency 'activeresource', '< 3'

  s.add_development_dependency 'rdoc'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'xml-simple'
  s.add_development_dependency 'rake', '>= 0.9.2'
end