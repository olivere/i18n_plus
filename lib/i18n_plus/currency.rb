require 'pathname'

module I18nPlus
  data_path = ::Pathname.new(File.dirname(__FILE__) + '/../../data')
  CURRENCIES = ::YAML.load_file(data_path.join("currencies.yml"))

  def self.currencies(*args)
    options = args.extract_options!
    locale = (options[:locale] || I18n.locale || I18n.default_locale).to_s.downcase
    CURRENCIES[locale]
  end

  def self.currency_name(code, *args)
    currencies(*args)[code.to_s.upcase]
  end
end

module ActionView
  module Helpers
    module FormOptionsHelper
      def currency_select(object, method, priority_country_codes = nil, options = {}, html_options = {})
        InstanceTag.new(object, method, self, options.delete(:object)).to_currency_select_tag(priority_country_codes, options, html_options)
      end

      def currency_options_for_select(selected = nil, *priority_currency_codes)
        html = ""
        unless priority_currency_codes.empty?
          priority_currencies = priority_currency_codes.map { |code| [I18nPlus.currency_name(code), code] }
          unless priority_currencies.empty?
            html += options_for_select(priority_currencies, selected)
            html += "<option value=\"\" disabled=\"disabled\">----------</option>"
          end
        end
        all_currencies = I18nPlus.currencies.map { |code,name| [name, code] }.sort
        return html + options_for_select(all_currencies, priority_currency_codes.include?(selected) ? nil : selected)
      end
    end

    class InstanceTag
      def to_currency_select_tag(priority_currency_codes, options, html_options)
        html_options = html_options.stringify_keys
        add_default_name_and_id(html_options)
        value = value(object)
        opts = add_options(currency_options_for_select(value, *priority_currency_codes), options, value)
        content_tag(:select, opts, html_options)
      end
    end

    class FormBuilder
      def currency_select(method, priority_currency_codes = nil, options = {}, html_options = {})
        @template.currency_select(@object_name, method, priority_currency_codes, options.merge(:object => @object), html_options)
      end
    end
  end
end
