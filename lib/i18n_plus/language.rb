require 'pathname'

module I18nPlus
  data_path = ::Pathname.new(File.dirname(__FILE__) + '/../../data')
  LANGUAGES = ::YAML.load(File.open(data_path.join("languages.yml")))

  def self.languages(*args)
    options = args.extract_options!
    locale = (options[:locale] || I18n.locale || I18n.default_locale || :en).to_s[0..1].downcase
    # Fallback to English if we don't use English or German
    locale = 'en' unless ['de', 'en'].include?(locale)
    LANGUAGES[locale]
  end

  def self.language_name(code, *args)
    languages(*args)[code.to_s.upcase]
  end
end

module ActionView
  module Helpers
    module FormOptionsHelper
      def language_select(object, method, priority_language_codes = nil, options = {}, html_options = {})
        tag = if defined?(ActionView::Helpers::InstanceTag) &&
              ActionView::Helpers::InstanceTag.instance_method(:initialize).arity != 0
          InstanceTag.new(object, method, self, options.delete(:object))
        else
          LanguageSelect.new(object, method, self, options)
        end

        tag.to_language_select_tag(priority_language_codes, options, html_options)
      end

      def language_options_for_select(selected = nil, *priority_language_codes)
        html = "".html_safe
        unless priority_language_codes.empty?
          priority_languages = priority_language_codes.map { |code| [I18nPlus.language_name(code), code] }
          unless priority_languages.empty?
            html += options_for_select(priority_languages, selected)
            html += "<option value=\"\" disabled=\"disabled\">----------</option>".html_safe
          end
        end
        all_languages = I18nPlus.languages.map { |code,name| [name, code] }.sort
        return html + options_for_select(all_languages, priority_language_codes.include?(selected) ? nil : selected)
      end
    end

    module ToLanguageSelectTag
      def to_language_select_tag(priority_language_codes, options, html_options)
        options.symbolize_keys!
        html_options.stringify_keys!
        add_default_name_and_id(html_options)
        _, value = option_text_and_value(object)
        selected_value = options.has_key?(:selected) ? options[:selected] : value
        opts = add_options(language_options_for_select(selected_value, *priority_language_codes), options, value)
        content_tag(:select, opts, html_options)
      end
    end

    if defined?(ActionView::Helpers::InstanceTag) &&
        ActionView::Helpers::InstanceTag.instance_method(:initialize).arity != 0
      class InstanceTag
        include ToLanguageSelectTag
      end
    else
      class LanguageSelect < Tags::Base
        include ToLanguageSelectTag
      end
    end

    class FormBuilder
      def language_select(method, priority_language_codes = nil, options = {}, html_options = {})
        @template.language_select(@object_name, method, priority_language_codes, options.merge(:object => @object), html_options)
      end
    end
  end
end
