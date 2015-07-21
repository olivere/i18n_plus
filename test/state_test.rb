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

    if ActiveSupport::VERSION::STRING < '4.0'
      match = /<option value="BY" selected="selected">Bayern<\/option>/
    else
      match = /<option selected="selected" value="BY">Bayern<\/option>/
    end
    assert_match match, state_options_for_select('DE', 'BY').gsub(/\n/, '')
  end

  test "should return states of Germany in English" do
    I18n.locale = :en
    if ActiveSupport::VERSION::STRING < '4.0'
      match = /<option value="BY" selected="selected">Bavaria<\/option>/
    else
      match = /<option selected="selected" value="BY">Bavaria<\/option>/
    end
    assert_match match, state_options_for_select('DE', 'BY').gsub(/\n/, '')
  end

  test "should return state_select in English" do
    I18n.locale = :en
    assert_not_nil results = state_select(@account, :state, 'DE').gsub(/\n/, '')

    if ActiveSupport::VERSION::STRING < '4.0'
      assert_match /<select id="account_state" name="account\[state\]">/, results
      assert_match /<option value="BY" selected="selected">Bavaria<\/option>/, results
    else
      assert_match /<select name="account\[state\]" id="account_state">/, results
      assert_match /<option selected="selected" value="BY">Bavaria<\/option>/, results
    end
  end
end
