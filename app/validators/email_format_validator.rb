class EmailFormatValidator < ActiveModel::EachValidator

  FORMAT = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

  def validate_each(record, attribute, value)
    unless value =~ FORMAT
      record.errors.add(attribute, options[:message] || "is invalid")
    end

    record
  end
end
