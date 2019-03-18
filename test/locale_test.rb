require 'test_helper'

class LocaleTest < ActiveSupport::TestCase
  include ActionView::Helpers::FormOptionsHelper

  setup do
    @account = stub(:locale => 'de-DE', :to_s => 'account')
  end

  test "should have locales" do
    assert_not_nil I18nPlus.locales
    assert !I18nPlus.locales.empty?
  end

  test "should return locale options for German" do
    I18n.locale = :de
    match = /<option selected="selected" value="de-DE">Deutsch \(Deutschland\)<\/option>/
    assert_match match, locale_options_for_select('de-DE').gsub(/\n/, '')
  end

  test "should return locale options for English" do
    I18n.locale = :en
    match = /<option selected="selected" value="de-DE">German \(Germany\)<\/option>/
    assert_match match, locale_options_for_select('de-DE').gsub(/\n/, '')
  end

  test "should return locale options with priority locale for English" do
    I18n.locale = :en
    match = /<option selected="selected" value="de-DE">German \(Germany\)<\/option><option value="" disabled="disabled">----------<\/option>/
    assert_match match, locale_options_for_select('de-DE', 'de-DE').gsub(/\n/, '')
  end

  test "should return locale options with multiple priority locales for English" do
    I18n.locale = :en
    match = /<option selected="selected" value="de-DE">German \(Germany\)<\/option><option value=\"en-GB\">English \(United Kingdom\)<\/option><option value="" disabled="disabled">----------<\/option>/
    assert_match match, locale_options_for_select('de-DE', 'de-DE', 'en-GB').gsub(/\n/, '')
  end

  test "should return locale_select" do
    I18n.locale = :en
    match = /<select name="account\[locale\]" id="account_locale"><option selected="selected" value="de-DE">German \(Germany\)<\/option><option value="" disabled="disabled">----------<\/option>/
    assert_match match, locale_select(@account, :locale, 'de-DE', {selected: 'de-DE'}).gsub(/\n/, '')
  end
end
