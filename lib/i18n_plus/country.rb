require 'pathname'

module I18nPlus
  data_path = ::Pathname.new(File.dirname(__FILE__) + '/../../data')
  COUNTRIES = ::YAML.load(File.open(data_path.join("countries.yml")))

  def self.countries(*args)
    options = args.extract_options!
    locale = (options[:locale] || I18n.locale || I18n.default_locale).to_s.downcase
    COUNTRIES[locale]
  end

  def self.country_name(code, *args)
    countries(*args)[code.to_s.upcase]
  end
end

module ActionView
  module Helpers
    module FormOptionsHelper
      def country_select(object, method, priority_country_codes = nil, options = {}, html_options = {})
        InstanceTag.new(object, method, self, options.delete(:object)).to_country_select_tag(priority_country_codes, options, html_options)
      end

      def country_options_for_select(selected = nil, *priority_country_codes)
        html = ""
        unless priority_country_codes.empty?
          priority_countries = priority_country_codes.map { |code| [I18nPlus.country_name(code), code] }
          unless priority_countries.empty?
            html += options_for_select(priority_countries, selected)
            html += "<option value=\"\" disabled=\"disabled\">----------</option>"
          end
        end
        all_countries = I18nPlus.countries.map { |code,name| [name, code] }.sort
        return html + options_for_select(all_countries, priority_country_codes.include?(selected) ? nil : selected)
      end
    end

    class InstanceTag
      def to_country_select_tag(priority_country_codes, options, html_options)
        html_options = html_options.stringify_keys
        add_default_name_and_id(html_options)
        value = value(object)
        opts = add_options(country_options_for_select(value, *priority_country_codes), options, value)
        content_tag(:select, opts, html_options)
      end
    end

    class FormBuilder
      def country_select(method, priority_country_codes = nil, options = {}, html_options = {})
        @template.country_select(@object_name, method, priority_country_codes, options.merge(:object => @object), html_options)
      end
    end
  end
end
