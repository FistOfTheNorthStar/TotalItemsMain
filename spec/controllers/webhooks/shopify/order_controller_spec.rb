require 'rails_helper'
require 'webmock/rspec'

RSpec.describe(Webhooks::Shopify::OrderController, type: :controller) do
  let(:order_cancelled) { File.read(Rails.root.join("spec", "fixtures", "shopify", "order_cancelled.json")) }
  let(:order_refunded) { File.read(Rails.root.join("spec", "fixtures", "shopify", "order_refunded.json")) }
  let(:order_fulfilled) { File.read(Rails.root.join("spec", "fixtures", "shopify", "order_fulfilled.json")) }

  let(:hmac) { 'valid_hmac' }

  before do
    WebMock.disable_net_connect!(allow_localhost: true)
    stub_request(:post, ENV['SLACK_WEBHOOK_URL'])
      .to_return(status: 200)
    allow_any_instance_of(described_class).to(receive(:verify_webhook).and_return(true))
    request.headers['HTTP_X_SHOPIFY_HMAC_SHA256'] = hmac
  end

  describe 'POST #create' do
    context 'with valid data' do
      it 'creates a new user' do
        expect {
          post(:create, body: user_created)
        }.to(change(User, :count).by(1))

        user_json = JSON.parse(user_created, symbolize_names: true)
        expect(response).to(have_http_status(:ok))
        user_last = User.last
        expect(user_last.email).to(eq(user_json[:email]))
        expect(user_last.address_1).to(eq(user_json[:default_address][:address1]))
        expect(user_last.phone).to(eq(user_json[:default_address][:phone]))
        expect(user_last.shopify_id).to(eq(user_json[:id].to_s))
        expect(user_last.phone_prefix).to(eq(27))
      end

      it 'enqueues a slack notification for user' do
        expect {
          post(:create, body: user_created)
        }.to(change(SlackNotificationJob.jobs, :size).by(1))
      end

      it 'updates existing user shopify_id' do
        user_json = JSON.parse(user_created, symbolize_names: true)
        user = create(:user, email: user_json[:email])

        expect {
          post(:create, body: user_created)
        }.not_to(change(User, :count))

        expect(user.reload.shopify_id).to(eq(user_json[:id].to_s))
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
