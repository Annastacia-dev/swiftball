class RestrictedKeywordsValidator < ActiveModel::EachValidator
  RESTRICTED_KEYWORDS = [
    'admin', 'administrator', 'swiftball', 'swiftball online', 'swiftball admin', ''
  ]

  def validate_each(record, attribute, value)
    if RESTRICTED_KEYWORDS.any? { |keyword| value.to_s.downcase.include?(keyword) }
      record.errors.add(attribute, :invalid, message: "contains restricted words")
    end
  end
end

