require 'pathname'

module I18nPlus
  data_path = ::Pathname.new(File.dirname(__FILE__) + '/../../data')
  STATES = ::YAML.load(File.open(data_path.join("states.yml")))

  def self.states(country_code, *args)
    options = args.extract_options!
    locale = (options[:locale] || I18n.locale || I18n.default_locale || :en).to_s[0..1].downcase
    # Fallback to English if we don't use English or German
    locale = 'en' unless ['de', 'en'].include?(locale)
    STATES[locale][country_code.to_s.upcase]
  end

  def self.state_name(country_code, state_code, *args)
    states(country_code, *args)[code.to_s.upcase]
  end
end

module ActionView
  module Helpers
    module FormOptionsHelper
      def state_select(object, method, country_code, options = {}, html_options = {})
        tag = if defined?(ActionView::Helpers::InstanceTag) &&
              ActionView::Helpers::InstanceTag.instance_method(:initialize).arity != 0
          InstanceTag.new(object, method, self, options.delete(:object))
        else
          StateSelect.new(object, method, self, options)
        end
        tag.to_state_select_tag(country_code, options, html_options)
      end

      def state_options_for_select(country_code, selected = nil)
        all_states = I18nPlus.states(country_code).map { |code,name| [name, code] }.sort
        options_for_select(all_states, selected)
      end
    end

    module ToStateSelectTag
      def to_state_select_tag(country_code, options, html_options)
        html_options = html_options.stringify_keys
        add_default_name_and_id(html_options)
        value = value(object)
        opts = add_options(state_options_for_select(country_code, value), options, value)
        content_tag(:select, opts, html_options)
      end
    end

    if defined?(ActionView::Helpers::InstanceTag) &&
        ActionView::Helpers::InstanceTag.instance_method(:initialize).arity != 0
      class InstanceTag
        include ToStateSelectTag
      end
    else
      class StateSelect < Tags::Base
        include ToStateSelectTag
      end
    end

    class FormBuilder
      def state_select(method, country_code, options = {}, html_options = {})
        @template.country_select(@object_name, method, country_code, options.merge(:object => @object), html_options)
      end
    end
  end
end
