# spec/controllers/webhooks/shopify/user_controller_spec.rb
require 'rails_helper'

RSpec.describe(Webhooks::Shopify::UserController, type: :controller) do
  let(:shopify_data) do
    {
      "id" => 123456789,
      "email" => "test@example.com",
      "default_address" => {
        "address1" => "123 Test St",
        "address2" => "Apt 4",
        "city" => "Test City",
        "province" => "ON",
        "country_code" => "CA",
        "phone" => "1234567890",
        "company" => nil
      }
    }
  end

  let(:hmac) { 'valid_hmac' }

  before do
    allow_any_instance_of(described_class).to(receive(:verify_webhook).and_return(true))
    request.headers['HTTP_X_SHOPIFY_HMAC_SHA256'] = hmac
  end

  describe 'POST #create' do
    context 'with valid data' do
      it 'creates a new user' do
        expect {
          post(:create, body: shopify_data.to_json)
        }.to(change(User, :count).by(1))

        expect(response).to(have_http_status(:ok))
        expect(User.last.email).to(eq(shopify_data["email"]))
      end

      it 'updates existing user shopify_id' do
        user = create(:user, email: shopify_data["email"])

        expect {
          post(:create, body: shopify_data.to_json)
        }.not_to(change(User, :count))

        expect(user.reload.shopify_id).to(eq(shopify_data["id"]))
        expect(response).to(have_http_status(:ok))
      end
    end

    context 'with invalid data' do
      it 'returns bad request for invalid JSON' do
        post :create, body: 'invalid json'
        expect(response).to(have_http_status(:bad_request))
      end
    end
  end
end