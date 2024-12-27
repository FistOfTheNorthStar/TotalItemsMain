module SharedValidators
  extend ActiveSupport::Concern

  def sanitize_string_fields(value)
    sanitized_no_trunc(value)
      .truncate(255, omission: "")
  end

  def sanitized_no_trunc(value)
    sanitized = ActionController::Base.helpers.sanitize(value, tags: [], attributes: [])
    sanitized
      .strip.gsub(/[[:space:]]+/, " ")
      .gsub(/<\/?[^>]*>/, "")
      .gsub(/javascript:/i, "")
      .gsub(/data:/i, "")
      .then { |cleaned| CGI.escape(cleaned) }
  end

  def sanitize_phone(value)
    value
      .gsub(/[^0-9()\- ]/, '')
      .gsub(/[[:space:]]+/, "")
      .truncate(20, omission: "")
  end
end
