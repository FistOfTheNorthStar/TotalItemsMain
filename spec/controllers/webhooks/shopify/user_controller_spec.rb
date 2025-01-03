require 'rails_helper'
require 'webmock/rspec'

RSpec.describe(Webhooks::Shopify::UserController, type: :controller) do
  let(:hmac_header) { "dummy_hmac" }
  let(:created_raw_post_data) { file_fixture('shopify/user_created.json').read }
  let(:created_parsed_data) { JSON.parse(created_raw_post_data, symbolize_names: true) }
  let(:deleted_raw_post_data) { file_fixture('shopify/user_deleted.json').read }

  before do
    WebMock.disable_net_connect!(allow_localhost: true)
    stub_request(:post, ENV['SLACK_WEBHOOK_URL'])
      .to_return(status: 200)
    request.headers["HTTP_X_SHOPIFY_HMAC_SHA256"] = hmac_header
    allow(controller).to(receive(:verify_webhook).and_return(true))
  end

  describe 'POST #create' do
    context 'with valid data' do
      it 'creates a new user' do
        expect {
          post(:create, body: created_raw_post_data)
        }.to(change(User, :count).by(1))
        expect(response).to(have_http_status(:ok))
        user_last = User.last
        expect(user_last.email).to(eq(created_parsed_data[:email]))
        expect(user_last.address_1).to(eq(created_parsed_data[:default_address][:address1]))
        expect(user_last.phone).to(eq(created_parsed_data[:default_address][:phone]))
        expect(user_last.shopify_id).to(eq(created_parsed_data[:id].to_s))
        expect(user_last.phone_prefix).to(eq(27))
      end

      it 'enqueues a slack notification for user created' do
        expect {
          post(:create, body: created_raw_post_data)
        }.to(change(SlackNotificationJob.jobs, :size).by(1))

        last_job = SlackNotificationJob.jobs.last
        expect(last_job["args"]).to(eq([ "User created in Shopify: bob@biller.com" ]))
      end

      it 'enqueues a slack notification for user deleted' do
        expect {
          post(:deleted, body: deleted_raw_post_data)
        }.to(change(SlackNotificationJob.jobs, :size).by(1))

        last_job = SlackNotificationJob.jobs.last
        expect(last_job["args"]).to(eq([ "User deleted ShopifyID: 706405506930370084" ]))
      end

      it 'updates existing user shopify_id' do
        user_json = JSON.parse(created_raw_post_data, symbolize_names: true)
        user = create(:user, email: user_json[:email])

        expect {
          post(:create, body: created_raw_post_data)
        }.not_to(change(User, :count))
        expect(user.shopify_id).to(eq(""))
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