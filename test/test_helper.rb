require 'rubygems'
require 'bundler/setup'
require 'minitest/autorun'
require 'active_support'
require 'action_view'
require 'minitest/unit'
require 'mocha/minitest'
require 'i18n_plus'
MiniTest.autorun

# Do not enfore available locales
I18n.enforce_available_locales = false

ActiveSupport.test_order = :random
