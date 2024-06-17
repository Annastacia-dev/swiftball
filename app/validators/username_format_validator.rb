# app/validators/username_format_validator.rb
class UsernameFormatValidator < ActiveModel::EachValidator
  ALLOWED_CHARACTERS_REGEX = /\A[a-zA-Z0-9_\-!?()]*\z/

  def validate_each(record, attribute, value)
    if value.include?('@')
      record.errors.add(attribute, :invalid, message: "cannot contain '@' symbol")
    elsif value !~ ALLOWED_CHARACTERS_REGEX
      record.errors.add(attribute, :invalid, message: "can only contain letters, numbers, '_', '-', '!', '?', '(', ')'")
    end
  end
end
