# app/validators/email_validator.rb
require 'resolv'

class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ URI::MailTo::EMAIL_REGEXP && valid_email?(value)
      record.errors.add(attribute, :invalid, message: "is not a valid email")
    end
  end

  private

  def valid_email?(email)
    return false if email.length < 5
    return false if email.count('@') != 1

    local_part, domain_part = email.split('@')
    return false if local_part.length < 2 || domain_part.length < 3
    return false if domain_part.count('.') < 1

    domain_name, domain_suffix = domain_part.split('.')
    return false if domain_name.length < 2 || domain_suffix.length < 2

    valid_domain?(domain_part)
  end

  def valid_domain?(domain)
    mx_records = []
    begin
      mx_records = Resolv::DNS.open do |dns|
        dns.getresources(domain, Resolv::DNS::Resource::IN::MX)
      end
    rescue Resolv::ResolvError
      return false
    end
    mx_records.any?
  end
end
