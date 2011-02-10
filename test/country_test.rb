# encoding: UTF-8

require 'test_helper'

class CountryTest < ActiveSupport::TestCase
  include ActionView::Helpers::FormOptionsHelper

  setup do
    @account = stub(:country => 'DE', :to_s => 'account')
  end

  test "should have countries" do
    assert_not_nil I18nPlus.countries
    assert !I18nPlus.countries.empty?
  end

  test "should return country name in German with I18n.locale set" do
    I18n.locale = :de
    assert_equal "Großbritannien", I18nPlus.country_name('GB')
  end

  test "should return country name in English with I18n.locale set" do
    I18n.locale = :en
    assert_equal "United Kingdom", I18nPlus.country_name('GB')
  end

  test "should return country name in German with locale option" do
    assert_equal "Großbritannien", I18nPlus.country_name('GB', :locale => :de)
  end

  test "should return country name in English with locale option" do
    assert_equal "United Kingdom", I18nPlus.country_name('GB', :locale => :en)
  end

  test "should return country name in German as locale option has precedence over I18n.locale" do
    I18n.locale = :en
    assert_equal "Großbritannien", I18nPlus.country_name('GB', :locale => :de)
    I18n.locale = :de
    assert_equal "United Kingdom", I18nPlus.country_name('GB', :locale => :en)
  end

  test "should return country options for German" do
    I18n.locale = :de
    match = /<option value="DE" selected="selected">Deutschland<\/option>/
    assert_match match, country_options_for_select('DE').gsub(/\n/, '')
  end

  test "should return country options for English" do
    I18n.locale = :en
    match = /<option value="DE" selected="selected">Germany<\/option>/
    assert_match match, country_options_for_select('DE').gsub(/\n/, '')
  end

  test "should return country options with priority countries for English" do
    I18n.locale = :en
    match = /<option value="DE" selected="selected">Germany<\/option><option value="" disabled="disabled">----------<\/option>/
    assert_match match, country_options_for_select('DE', 'DE').gsub(/\n/, '')
  end

  test "should return country options with multiple priority countries for English" do
    I18n.locale = :en
    match = /<option value="DE" selected="selected">Germany<\/option><option value=\"GB\">United Kingdom<\/option><option value="" disabled="disabled">----------<\/option>/
    assert_match match, country_options_for_select('DE', 'DE', 'GB').gsub(/\n/, '')
  end

  test "should return country_select" do
    I18n.locale = :en
    match = /<select id="account_country" name="account\[country\]"><option value="DE" selected="selected">Germany<\/option><option value="" disabled="disabled">----------<\/option>/
    assert_match match, country_select(@account, :country, 'DE').gsub(/\n/, '')
  end
end
