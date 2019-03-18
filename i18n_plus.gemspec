# -*- encoding: utf-8 -*-
require File.expand_path('../lib/i18n_plus/version', __FILE__)

extra_rdoc_files = ['CHANGELOG.md', 'LICENSE', 'README.md']

Gem::Specification.new do |s|
  s.name             = 'i18n_plus'
  s.version          = I18nPlus::VERSION
  s.author           = ['Oliver Eilhard']
  s.description      = %q{A library for i18n of countries, states, currencies, and locales.}
  s.email            = ['oliver.eilhard@gmail.com']
  s.extra_rdoc_files = extra_rdoc_files
  s.homepage         = 'http://github.com/olivere/i18n_plus'
  s.rdoc_options     = ['--charset=UTF-8']
  s.require_paths    = ['lib']
  s.summary          = %q{Internally used for working with countries, currencies, and locales. Only supports English and German.}
  s.license          = "MIT"
  s.files            = `git ls-files -- {bin,lib,spec,data}/*`.split("\n") + extra_rdoc_files
  s.executables      = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.test_files       = `git ls-files -- test/*_test.rb`.split("\n")

  s.add_dependency 'rack', '~> 2.0'
  s.add_dependency 'activesupport', ['>= 5.2.2.1', '< 6']
  s.add_dependency 'actionpack', ['>= 5.2.2.1', '< 6']
  s.add_development_dependency("bundler", "~> 1.16")
  s.add_development_dependency("rdoc", "~> 6.0")
  s.add_development_dependency("mocha", "~> 1.4")
  s.add_development_dependency("rake", "~> 12.3")
  # s.add_development_dependency("minitest", "~> 5.11")
end

