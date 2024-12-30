module SharedValidators
  extend ActiveSupport::Concern

  def sanitize_string_fields(value)
    sanitized_no_trunc(value)
      .truncate(255, omission: "")
  end

  def sanitized_no_trunc(value)
    return "" if value.blank?
    sanitized = sanitize(value, tags: [], attributes: [])
    sanitized.gsub(/[[:space:]]+/, " ")
             .gsub!(/[\u0000-\u001F\u007F-\u009F]/, "")
             .strip
  end

  def sanitize_phone(value)
    return "" if value.blank?
    value
      .gsub(/[^0-9()\- ]/, "")
      .gsub(/[[:space:]]+/, "")
      .truncate(20, omission: "")
  end
end
