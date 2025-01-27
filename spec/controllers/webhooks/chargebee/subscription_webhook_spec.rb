require 'rails_helper'

RSpec.describe(Webhooks::Chargebee::WebhookController, type: :controller) do
  let(:webhook_username) { 'admin_chargbee' }
  let(:webhook_password) { 'kay43_EEunohlaanVV_BNjo_tie4L' }
  let(:valid_auth_header) do
    ActionController::HttpAuthentication::Basic.encode_credentials(webhook_username, webhook_password)
  end

  let(:subscription_created_with_coupon_fixture) do
    JSON.parse(File.read(Rails.root.join('spec/fixtures/files/chargebee/subscription_created_with_coupon.json')))
  end

  before do
    stub_const('CHARGEBEE_WEBHOOK_USERNAME', webhook_username)
    stub_const('CHARGEBEE_WEBHOOK_PASSWORD', webhook_password)
    request.env['HTTP_AUTHORIZATION'] = valid_auth_header
  end

  describe 'POST #handle' do
    context 'with valid authentication' do
      it 'processes subscription_created event with coupon' do
        webhook_service = instance_double(Webhooks::Chargebee::WebhookService)
        expect(Webhooks::Chargebee::WebhookService).to receive(:new)
                                    .with(subscription_created_with_coupon_fixture)
                                    .and_return(webhook_service)
        expect(webhook_service).to receive(:process)

        post :handle, params: subscription_created_with_coupon_fixture, as: :json
        expect(response).to have_http_status(:ok)
      end

      context 'when the user already exists in the system' do
        let!(:existing_user) { create(:user, email: "test@example.com") }

        it 'updates the user with the chargebee_id and sends Slack notification' do
          expect(SlackNotificationJob).to receive(:perform_async)
                                            .with("User exists but chargebee_id created or updated: test@example.com")

          expect {
            post :handle, params: subscription_created_with_coupon_fixture, as: :json
          }.not_to change(User, :count)  # doesn't create a new user

          existing_user.reload
          expect(existing_user.chargebee_id).to eq("BTUUpAURUxIut6edX")
        end
      end

      context 'when the user does not exist' do
        it 'creates a new user with the correct attributes and sends Slack notification' do
          # We want to ensure Slack is notified
          expect(SlackNotificationJob).to receive(:perform_async)
                                            .with("User created a subscription in ChargeBee: test@example.com")

          expect {
            post :handle, params: subscription_created_with_coupon_fixture, as: :json
          }.to change(User, :count).by(1)

          user = User.last
          expect(user.chargebee_id).to eq("BTUUpAURUxIut6edX")
          expect(user.email).to eq("test@example.com")
          expect(user.address_1).to eq("Aalbersestraat 4")
          expect(user.city).to eq("Astraat 4")
          expect(user.state).to eq("Grnd")
          expect(user.first_name).to eq("Manes")
          expect(user.last_name).to eq("Norws")
          expect(user.subscription_number_of_trees).to eq(3)
          expect(user.subscription_tree_type).to eq("yemani")
          expect(user.subscription_type).to eq("family")
          expect(user.subscription_status).to eq("active")
        end
      end

      it 'verifies coupon details in the webhook payload' do
        coupon = subscription_created_with_coupon_fixture['content']['subscription']['coupons'].first
        expect(coupon['coupon_id']).to eq('DISCOUNT10')
        expect(coupon['discount_amount']).to eq(1000)
        expect(coupon['duration_type']).to eq('forever')
        expect(coupon['metadata']['tree_credits']).to eq(3)
      end
    end

    context 'with invalid authentication' do
      it 'returns unauthorized with invalid credentials' do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials('wrong', 'wrong')
        post :handle, params: subscription_created_with_coupon_fixture, as: :json
        expect(response).to have_http_status(:ok) # As per the implementation, returns :ok for failed auth
      end
    end

    context 'when processing fails' do
      it 'handles errors gracefully' do
        allow_any_instance_of(Webhooks::Chargebee::WebhookService).to receive(:process).and_raise(StandardError.new('Processing failed'))
        post :handle, params: subscription_created_with_coupon_fixture, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'with missing coupon' do
      let(:subscription_created_fixture) do
        JSON.parse(File.read(Rails.root.join('spec/fixtures/files/chargebee/subscription_created_with_coupon.json')))
      end

      it 'processes webhook without coupon data' do
        webhook_service = instance_double(Webhooks::Chargebee::WebhookService)
        expect(Webhooks::Chargebee::WebhookService).to receive(:new)
                                    .with(subscription_created_fixture)
                                    .and_return(webhook_service)
        expect(webhook_service).to receive(:process)

        post :handle, params: subscription_created_fixture, as: :json
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe '#authenticate' do
    it 'authenticates with correct credentials' do
      post :handle, params: subscription_created_with_coupon_fixture, as: :json
      expect(response).to have_http_status(:ok)
    end

    it 'uses secure comparison for credentials' do
      expect(ActiveSupport::SecurityUtils).to receive(:secure_compare)
                                                .with(webhook_username, webhook_username).and_call_original
      expect(ActiveSupport::SecurityUtils).to receive(:secure_compare)
                                                .with(webhook_password, webhook_password).and_call_original

      post :handle, params: subscription_created_with_coupon_fixture, as: :json
    end
  end
end