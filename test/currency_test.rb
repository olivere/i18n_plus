# encoding: UTF-8

require 'test_helper'

class CurrencyTest < ActiveSupport::TestCase
  include ActionView::Helpers::FormOptionsHelper

  setup do
    @account = stub(:currency => 'EUR', :to_s => 'account')
  end

  test "should have currencies" do
    assert_not_nil I18nPlus.currencies
    assert !I18nPlus.currencies.empty?
  end

  test "should return currency options for German" do
    I18n.locale = :de
    match = /<option value="EUR" selected="selected">EUR \(€\)<\/option>/
    assert_match match, currency_options_for_select('EUR').gsub(/\n/, '')
  end

  test "should return currency options for English" do
    I18n.locale = :en
    match = /<option value="EUR" selected="selected">EUR \(€\)<\/option>/
    assert_match match, currency_options_for_select('EUR').gsub(/\n/, '')
  end

  test "should return currency options with priority currencies for English" do
    I18n.locale = :en
    match = /<option value="EUR" selected="selected">EUR \(€\)<\/option><option value="" disabled="disabled">----------<\/option>/
    assert_match match, currency_options_for_select('EUR', 'EUR').gsub(/\n/, '')
  end

  test "should return currency options with multiple priority currencies for English" do
    I18n.locale = :en
    match = /<option value="EUR" selected="selected">EUR \(€\)<\/option><option value=\"USD\">USD \(\$\)<\/option><option value="" disabled="disabled">----------<\/option>/
    assert_match match, currency_options_for_select('EUR', 'EUR', 'USD').gsub(/\n/, '')
  end

  test "should return currency_select" do
    I18n.locale = :en
    match = /<select id="account_currency" name="account\[currency\]"><option value="EUR" selected="selected">EUR \(€\)<\/option><option value="" disabled="disabled">----------<\/option>/
    assert_match match, currency_select(@account, :currency, 'EUR').gsub(/\n/, '')
  end
end
