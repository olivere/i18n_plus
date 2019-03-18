require 'test_helper'

class StateTest < ActiveSupport::TestCase
  include ActionView::Helpers::FormOptionsHelper

  setup do
    @account = stub(:country => 'DE', :state => 'BY', :to_s => 'account')
  end

  test "should have states" do
    assert_not_nil I18nPlus.states('DE')
    assert !I18nPlus.states('DE').empty?
  end

  test "should return states of Germany in German" do
    I18n.locale = :de
    match = /<option selected="selected" value="BY">Bayern<\/option>/
    assert_match match, state_options_for_select('DE', 'BY').gsub(/\n/, '')
  end

  test "should return states of Germany with BE selected" do
    I18n.locale = :de
    match = /<option selected="selected" value="BE">Berlin<\/option>/
    assert_match match, state_options_for_select('DE', 'BE').gsub(/\n/, '')
  end

  test "should return states of Germany in English" do
    I18n.locale = :en
    match = /<option selected="selected" value="BY">Bavaria<\/option>/
    assert_match match, state_options_for_select('DE', 'BY').gsub(/\n/, '')
  end

  test "should return state_select in English" do
    I18n.locale = :en
    assert_not_nil results = state_select(@account, :state, 'DE', {selected: 'BY'}).gsub(/\n/, '')
    assert_match(/<select name="account\[state\]" id="account_state">/, results)
    assert_match(/<option selected="selected" value="BY">Bavaria<\/option>/, results)
  end
end
