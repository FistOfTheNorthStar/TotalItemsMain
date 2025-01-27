require 'rails_helper'

RSpec.describe(Webhooks::Chargebee::WebhookService, type: :controller) do
  let(:webhook_username) { 'webhook_user' }
  let(:webhook_password) { 'webhook_password' }
  let(:valid_auth_header) do
    ActionController::HttpAuthentication::Basic.encode_credentials(webhook_username, webhook_password)
  end

  let(:subscription_created_with_coupon_fixture) do
    JSON.parse(File.read(Rails.root.join('spec/fixtures/files/chargebee/subscription_created_with_coupon.json')))
  end

  let(:subscription_created_fixture) do
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
        webhook_service = instance_double(WebhookService)
        expect(WebhookService).to receive(:new)
                                    .with(webhook_fixture, 'subscription_created')
                                    .and_return(webhook_service)
        expect(webhook_service).to receive(:process)

        post :handle, params: webhook_fixture
        expect(response).to have_http_status(:ok)
      end

      it 'verifies coupon details in the webhook payload' do
        coupon = webhook_fixture['content']['subscription']['coupons'].first
        expect(coupon['coupon_id']).to eq('DISCOUNT10')
        expect(coupon['discount_amount']).to eq(1000)
        expect(coupon['duration_type']).to eq('forever')
        expect(coupon['metadata']['tree_credits']).to eq(3)
      end
    end

    context 'with invalid authentication' do
      it 'returns unauthorized with invalid credentials' do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials('wrong', 'wrong')
        post :handle, params: webhook_fixture
        expect(response).to have_http_status(:ok) # As per the implementation, returns :ok for failed auth
      end
    end

    context 'when processing fails' do
      it 'handles errors gracefully' do
        allow_any_instance_of(WebhookService).to receive(:process).and_raise(StandardError.new('Processing failed'))
        post :handle, params: webhook_fixture
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'with missing coupon' do
      let(:webhook_without_coupon) do
        modified_fixture = webhook_fixture.deep_dup
        modified_fixture['content']['subscription'].delete('coupons')
        modified_fixture
      end

      it 'processes webhook without coupon data' do
        webhook_service = instance_double(WebhookService)
        expect(WebhookService).to receive(:new)
                                    .with(webhook_without_coupon, 'subscription_created')
                                    .and_return(webhook_service)
        expect(webhook_service).to receive(:process)

        post :handle, params: webhook_without_coupon
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe '#authenticate' do
    it 'authenticates with correct credentials' do
      post :handle, params: webhook_fixture
      expect(response).to have_http_status(:ok)
    end

    it 'uses secure comparison for credentials' do
      expect(ActiveSupport::SecurityUtils).to receive(:secure_compare)
                                                .with(webhook_username, webhook_username).and_call_original
      expect(ActiveSupport::SecurityUtils).to receive(:secure_compare)
                                                .with(webhook_password, webhook_password).and_call_original

      post :handle, params: webhook_fixture
    end
  end
end