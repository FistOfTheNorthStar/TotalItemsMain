module ShareVariablesConstantsRegex
  PAYMENT_JOB_EXPIRES = 5.minutes
  PAYMENT_JOB_RETRIES = 5
  REPLACE_THIS= "TO BE REPLACED!" # Replace this text dynamically
  # This is more strict than URI::MailTo::EMAIL_REGEXP which allows test.@mailer.com
  # rubocop:disable Layout/LineLength
  VALID_EMAIL_REGEX = /\A(?=[^@]*@[^@]*\z)[a-zA-Z0-9!#$%&*+?^{|}~-]+(?:[.][a-zA-Z0-9!#$%&*+?^{|}~-]+)*[^.\\]@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*\.[a-zA-Z]{2,6}\z/
  # VALID_EMAIL_REGEX = URI::MailTo::EMAIL_REGEXP # you could populate database with bad emails and cause a lot of errors
end
