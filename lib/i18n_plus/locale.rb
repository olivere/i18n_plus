require 'pathname'

module I18nPlus
  data_path = ::Pathname.new(File.dirname(__FILE__) + '/../../data')
  LOCALES = ::YAML.load(File.open(data_path.join("locales.yml")))

  def self.locales(*args)
    options = args.extract_options!
    locale = (options[:locale] || I18n.locale || I18n.default_locale).to_s.downcase
    LOCALES[locale]
  end

  def self.locale_name(code, *args)
    locales(*args)[code.to_s]
  end
end

module ActionView
  module Helpers
    module FormOptionsHelper
      def locale_select(object, method, priority_locale_codes = nil, options = {}, html_options = {})
        tag = if defined?(ActionView::Helpers::InstanceTag) &&
              ActionView::Helpers::InstanceTag.instance_method(:initialize).arity != 0
          InstanceTag.new(object, method, self, options.delete(:object))
        else
          LocaleSelect.new(object, method, self, options)
        end
        tag.to_locale_select_tag(priority_locale_codes, options, html_options)
      end

      def locale_options_for_select(selected = nil, *priority_locale_codes)
        html = "".html_safe
        unless priority_locale_codes.empty?
          priority_locales = priority_locale_codes.map { |code| [I18nPlus.locale_name(code), code] }
          unless priority_locales.empty?
            html += options_for_select(priority_locales, selected)
            html += "<option value=\"\" disabled=\"disabled\">----------</option>".html_safe
          end
        end
        all_locales = I18nPlus.locales.map { |code,name| [name, code] }.sort
        return html + options_for_select(all_locales, priority_locale_codes.include?(selected) ? nil : selected)
      end
    end

    module ToLocaleSelectTag
      def to_locale_select_tag(priority_locale_codes, options, html_options)
        html_options = html_options.stringify_keys
        add_default_name_and_id(html_options)
        value = value(object)
        opts = add_options(locale_options_for_select(value, *priority_locale_codes), options, value)
        content_tag(:select, opts, html_options)
      end
    end

    if defined?(ActionView::Helpers::InstanceTag) &&
        ActionView::Helpers::InstanceTag.instance_method(:initialize).arity != 0
      class InstanceTag
        include ToLocaleSelectTag
      end
    else
      class LocaleSelect < Tags::Base
        include ToLocaleSelectTag
      end
    end

    class FormBuilder
      def locale_select(method, priority_locale_codes = nil, options = {}, html_options = {})
        @template.locale_select(@object_name, method, priority_locale_codes, options.merge(:object => @object), html_options)
      end
    end
  end
end
