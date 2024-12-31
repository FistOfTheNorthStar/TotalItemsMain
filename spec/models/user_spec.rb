require 'rails_helper'

# SOME USE EXAMPLES FOR COUNTRY AND PHONE_PREFIX
# user = User.new(
#   country: :estonia,      # code 47
#   phone_prefix: :estonia, # code 47
#   phone: '12345678'
# )
# user.valid? # true
#
# user.country = :finland
# user.phone_prefix = :estonia
# user.valid? # false
# user.errors.full_messages

RSpec.describe(User, type: :model) do
  let(:account) { create(:account) }
  let(:valid_attributes) do
    {
      email: "test@example.com",
      shipping_address: "123 Test St",
      phone: "+1 (555) 123-4567",
      account: account
    }
  end

  describe "validations" do
    it "is valid with valid attributes" do
      customer = User.new(valid_attributes)
      expect(customer).to(be_valid)
    end

    it "is not valid without an email" do
      customer = User.new(valid_attributes.merge(email: nil))
      expect(customer).not_to(be_valid)
    end

    context "email format" do
      let(:customer) { build(:customer) }

      it "is not valid with invalid email formats" do
        invalid_emails = %w[test@ @example.com testexample.com test@example test.@example.com]

        invalid_emails = [
          "test.@example.com",
          "test@example",
          ".test@example.com",
          "test@.example.com",
          "test@example..com",
          "test..name@example.com",
          "test@example.com.",
          "@example.com",
          "test@",
          "test@example-.com",
          "test@-example.com",
          "test@example.com-",
          "test space@example.com",
          "test@exam ple.com",
          "test@example.c",
          "test@example.toolongTLD",
          "test@@example.com",
          "test@example@com",
          "test@example.com@",
          "test@example.123",
          "test()@example.com",
          "test[]@example.com",
          "test\\@example.com",
          "test'name@example.com",
          "test\"name@example.com",
          "test@example_.com",
          "test@example.com_",
          "_test@example.com",
          "test@example.c*m",
          "test@example.c#m",
          "test@example.c$m",
          "test@example.c%m",
          "test@example.c&m",
          "test@[example.com]",
          "test@example,com",
          "test@example;com",
          "test:name@example.com",
          "test/name@example.com",
          "test=name@example.com",
          "test@example.com/dept"
        ]

        invalid_emails.each do |email|
          customer.email = email
          expect(customer).not_to(be_valid)
          expect(customer.errors[:email]).to(include("is invalid"))
        end
      end

      it "is valid with proper email format" do
        valid_emails = %w[user@example.com user.name@example.com user+label@example.com user@sub.example.com]

        valid_emails.each do |email|
          customer.email = email
          expect(customer).to(be_valid)
        end
      end
    end

    it "is not valid without an account" do
      customer = User.new(valid_attributes.merge(account: nil))
      expect(customer).not_to(be_valid)
    end
  end

  describe "associations" do
    let(:customer) { create(:customer) }

    it "belongs to an account" do
      expect(customer.account).to(be_present)
    end

    it "has many sold_items" do
      expect(customer).to(respond_to(:sold_items))
      expect(customer.sold_items).to(be_an(ActiveRecord::Associations::CollectionProxy))
    end

    it "has many reservations through sold_items" do
      expect(customer).to(respond_to(:reservations))
      expect(customer.reservations).to(be_an(ActiveRecord::Associations::CollectionProxy))
    end
  end

  describe "data cleaning" do
    describe "#clean_address" do
      let(:customer) { User.new(valid_attributes) }

      it "removes extra whitespace" do
        customer.shipping_address = "123   Main   Street"
        customer.save
        expect(customer.shipping_address).to(eq("123 Main Street"))
      end

      it "truncates addresses longer than 255 characters" do
        long_address = "a" * 300
        customer.shipping_address = long_address
        customer.save
        expect(customer.shipping_address.length).to(eq(255))
      end

      it "handles nil address" do
        customer.shipping_address = nil
        expect { customer.save }.not_to(raise_error)
      end

      it "escapes special character, but can be read normally" do
        customer.shipping_address = "123 Main St. & Ave"
        customer.save
        expect(customer.shipping_address).to(include("&"))
      end

      it "escapes special character, but can be read normally" do
        customer.shipping_address = "123 Main<script='https://bad.js'> St. & Ave"
        customer.save
        expect(customer.shipping_address).not_to(include("<script='https://bad.js'>"))
      end
    end

    describe "#clean_phone" do
      let(:customer) { User.new(valid_attributes) }

      it "removes invalid characters" do
        customer.phone = "+1 (555) ABC-1234"
        customer.save
        expect(customer.phone).to(eq("+1(555)-1234"))
      end

      it "removes extra whitespace" do
        customer.phone = "+1   (555)   123-4567"
        customer.save
        expect(customer.phone).to(eq("+1(555)123-4567"))
      end

      it "truncates numbers longer than 20 characters" do
        customer.phone = "+1 (555) 123-4567 ext 12345678990"
        customer.save
        expect(customer.phone.length).to(eq(20))
      end

      it "handles nil phone" do
        customer.phone = nil
        expect { customer.save }.not_to(raise_error)
      end

      it "preserves valid characters" do
        valid_phone = "+1 (555) 123-4567"
        customer.phone = valid_phone
        customer.save
        expect(customer.phone).to(eq("+1(555)123-4567"))
      end
    end
  end

  describe "database constraints" do
    it "has a unique index on email" do
      expect(ActiveRecord::Base.connection.index_exists?(:customers, :email)).to(be(true))
    end

    it "has an index on account_id" do
      expect(ActiveRecord::Base.connection.index_exists?(:customers, :account_id)).to(be(true))
    end
  end

  describe "validation errors" do
    it "requires an account to be present" do
      customer = build(:customer, account: nil)
      customer.valid?
      expect(customer.errors[:account]).to(include("must exist"))
    end

    it "requires an email to be present" do
      customer = build(:customer, email: nil)
      customer.valid?
      expect(customer.errors[:email]).to(include("can't be blank"))
    end

    it "requires email to be in valid format" do
      customer = build(:customer, email: "invalid-email")
      customer.valid?
      expect(customer.errors[:email]).to(include("is invalid"))
    end
  end


  xss_test_cases = [
    # Unicode/encoding bypasses
    "javascript&#58;alert(1)",
    "javascript&#0058;alert(1)",
    "javascript&#x3A;alert(1)",
    "javascript\u3000:alert(1)",

    # Null byte injection
    "javascript\u0000:alert(1)",

    # Exotic whitespace
    "javascript\u2028alert(1)",

    # HTML encoding variations
    "&#106;&#97;&#118;&#97;&#115;&#99;&#114;&#105;&#112;&#116;&#58;alert(1)",

    # Protocol obfuscation
    "JaVaScRiPt:alert(1)",
    "\u006A\u0061\u0076\u0061\u0073\u0063\u0072\u0069\u0070\u0074\u003A alert(1)",

    # Data URI schemes
    "data:text/html;base64,PHNjcmlwdD5hbGVydCgxKTwvc2NyaXB0Pg==",

    # Event handlers
    "onmouseover=alert(1)",
    "<img/src='x'onerror=alert(1)>",

    # CSS with expressions
    "<style>*{background-image:url(javascript:alert(1))}</style>",

    # Meta refresh
    "<meta http-equiv='refresh' content='0;url=javascript:alert(1)'>",

    # SVG XSS
    "<svg/onload=alert(1)>",
    "<svg><script>alert(1)</script></svg>"
  ]

  # You can create a test method:
  def test_sanitization
    xss_test_cases.each do |xss|
      sanitized = ActionController::Base.helpers.sanitize(xss, tags: [], attributes: [])
      puts("Original: #{xss}")
      puts("Sanitized: #{sanitized}")
      puts("Safe? #{!sanitized.include?('script') && !sanitized.include?('javascript') && !sanitized.include?('alert')}")
      puts("---")
    end
  end

  # Additional test for database storage
  def test_database_safety
    test_user = User.create(
      email: "<script>alert('xss')</script>@test.com",
      name: "<img src=x onerror=alert(1)>",
        # ... other required fields with XSS attempts
      )

    puts("Stored email: #{test_user.email}")
    puts("Stored name: #{test_user.name}")
  end
end
