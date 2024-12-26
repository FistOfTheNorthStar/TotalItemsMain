require 'rails_helper'

RSpec.describe(Account, type: :model) do
  describe "validations" do
    it "is valid with valid attributes" do
      account = build(:account)
      expect(account).to(be_valid)
    end

    it "is not valid without a name" do
      account = build(:account, name: nil)
      account.valid?
      expect(account.errors[:name]).to(include("can't be blank"))
    end

    it "is not valid without an email" do
      account = build(:account, email: nil)
      account.valid?
      expect(account.errors[:email]).to(include("can't be blank"))
    end

    it "is not valid with a duplicate email" do
      create(:account, email: "test@example.com")
      account = build(:account, email: "test@example.com")
      account.valid?
      expect(account.errors[:email]).to(include("has already been taken"))
    end
  end

  describe "associations" do
    let(:account) { create(:account) }

    it "has many items" do
      expect(account).to(respond_to(:items))
      expect(account.items).to(be_an(ActiveRecord::Associations::CollectionProxy))
    end

    it "has many customers" do
      expect(account).to(respond_to(:customers))
      expect(account.customers).to(be_an(ActiveRecord::Associations::CollectionProxy))
    end

    it "has many sold_item through items" do
      expect(account).to(respond_to(:sold_items))
      expect(account.sold_items).to(be_an(ActiveRecord::Associations::CollectionProxy))
    end

    describe "with items" do
      let(:account_with_items) { create(:account, :with_items) }

      it "can have multiple items" do
        expect(account_with_items.items.count).to(eq(3))
      end

      it "destroys associated items when destroyed" do
        item_ids = account_with_items.items.pluck(:id)
        account_with_items.destroy
        expect(Item.where(id: item_ids)).to(be_empty)
      end
    end

    describe "with customers" do
      let(:account_with_customers) { create(:account, :with_customers) }

      it "can have multiple customers" do
        expect(account_with_customers.customers.count).to(eq(3))
      end

      it "destroys associated customers when destroyed" do
        customer_ids = account_with_customers.customers.pluck(:id)
        account_with_customers.destroy
        expect(User.where(id: customer_ids)).to(be_empty)
      end
    end
  end

  describe "database constraints" do
    it "has a unique index on email" do
      expect(ActiveRecord::Base.connection.index_exists?(:accounts, :email, unique: true)).to(be(true))
    end
  end

  describe "factory" do
    it "has a valid factory" do
      expect(build(:account)).to(be_valid)
    end

    it "has a valid factory with items" do
      expect(build(:account, :with_items)).to(be_valid)
    end

    it "has a valid factory with customers" do
      expect(build(:account, :with_customers)).to(be_valid)
    end

    it "has a valid factory with items and customers" do
      expect(build(:account, :with_items_and_customers)).to(be_valid)
    end

    it "has a valid factory with sold items" do
      expect(build(:account, :with_sold_items)).to(be_valid)
    end

    it "generates unique emails for each account" do
      account1 = create(:account)
      account2 = create(:account)
      expect(account1.email).not_to(eq(account2.email))
    end
  end
end