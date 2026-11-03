# app/validators/url_validator.rb
class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?

    uri = URI.parse(value)
    
    # Ensure the scheme is strictly http or https and a real host exists
    unless uri.is_a?(URI::HTTP) && uri.host.present? && uri.host.include?('.')
      record.errors.add(attribute, (options[:message] || "must be a valid URL (e.g., https://example.com)"))
    end
  rescue URI::InvalidURIError
    record.errors.add(attribute, (options[:message] || "is an invalid URL"))
  end
end
