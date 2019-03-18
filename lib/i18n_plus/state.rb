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
        collection = I18nPlus.states(country_code)
        options = collection.map { |code,name| [name, code] }.sort
        options_for_select(options, selected)
      end
    end

    module ToStateSelectTag
      def to_state_select_tag(country_code, options, html_options)
        options.symbolize_keys!
        html_options.stringify_keys!
        add_default_name_and_id(html_options)
        _, value = option_text_and_value(object)
        selected_value = options.has_key?(:selected) ? options[:selected] : value
        opts = add_options(state_options_for_select(country_code, selected_value), options, value)
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
