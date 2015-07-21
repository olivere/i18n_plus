require 'rubygems'
require 'bundler/setup'
require 'minitest/unit'
require 'active_support'
require 'action_view'
require 'mocha/setup'
require 'i18n_plus'
MiniTest::Unit.autorun

# Do not enfore available locales
I18n.enforce_available_locales = false
