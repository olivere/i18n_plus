# -*- encoding: utf-8 -*-
require File.expand_path('../lib/i18n_plus/version', __FILE__)

extra_rdoc_files = ['CHANGELOG.md', 'LICENSE', 'README.md']

Gem::Specification.new do |s|
  s.name = 'i18n_plus'
  s.version = I18nPlus::VERSION
  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6") if s.respond_to? :required_rubygems_version=
  s.authors = ['Oliver Eilhard']
  s.description = %q{A library for i18n of countries, states, currencies, and locales.}
  s.email = ['oliver.eilhard@gmail.com']
  s.extra_rdoc_files = extra_rdoc_files
  s.homepage = 'http://github.com/olivere/i18n_plus'
  s.rdoc_options = ['--charset=UTF-8']
  s.require_paths = ['lib']
  s.summary = s.description
  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.files = `git ls-files -- {bin,lib,spec,data}/*`.split("\n") + extra_rdoc_files
  s.test_files = `git ls-files -- test/*_test.rb`.split("\n")

  s.add_dependency 'rack', ['>= 1.1.0', '< 2']
  if RUBY_VERSION < '1.9.3'
    s.add_dependency 'activesupport', '~> 3.2.13'
    s.add_dependency 'actionpack', '~> 3.2.13'
  else
    s.add_dependency 'activesupport'
    s.add_dependency 'actionpack'
  end
  s.add_development_dependency("bundler", "~> 1.10.5")
  s.add_development_dependency("rdoc", "~> 2.5.3")
  s.add_development_dependency("mocha", "~> 1.1.0")
  s.add_development_dependency("rake")
  s.add_development_dependency("minitest")
end

