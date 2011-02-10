require 'test_helper'

class LanguageTest < ActiveSupport::TestCase
  include ActionView::Helpers::FormOptionsHelper

  setup do
    @account = stub(:language => 'DE', :to_s => 'account')
  end

  test "should have languages" do
    assert_not_nil I18nPlus.languages
    assert !I18nPlus.languages.empty?
  end

  test "should return language options for German" do
    I18n.locale = :de
    match = /<option value="DE" selected="selected">Deutsch<\/option>/
    assert_match match, language_options_for_select('DE').gsub(/\n/, '')
  end

  test "should return language options for English" do
    I18n.locale = :en
    match = /<option value="DE" selected="selected">German<\/option>/
    assert_match match, language_options_for_select('DE').gsub(/\n/, '')
  end

  test "should return language options with priority languages for English" do
    I18n.locale = :en
    match = /<option value="DE" selected="selected">German<\/option><option value="" disabled="disabled">----------<\/option>/
    assert_match match, language_options_for_select('DE', 'DE').gsub(/\n/, '')
  end

  test "should return language options with multiple priority languages for English" do
    I18n.locale = :en
    match = /<option value="DE" selected="selected">German<\/option><option value=\"EN\">English<\/option><option value="" disabled="disabled">----------<\/option>/
    assert_match match, language_options_for_select('DE', 'DE', 'EN').gsub(/\n/, '')
  end

  test "should return language_select" do
    I18n.locale = :en
    match = /<select id="account_language" name="account\[language\]"><option value="DE" selected="selected">German<\/option><option value="" disabled="disabled">----------<\/option>/
    assert_match match, language_select(@account, :language, 'DE').gsub(/\n/, '')
  end
end
