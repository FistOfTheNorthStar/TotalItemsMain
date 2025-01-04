require 'rails_helper'
require 'webmock/rspec'

RSpec.describe(Webhooks::Shopify::OrderController, type: :controller) do
  let(:order_cancelled) { File.read(Rails.root.join("spec", "fixtures", "shopify", "order_cancelled.json")) }
  let(:order_refunded) { File.read(Rails.root.join("spec", "fixtures", "shopify", "order_refunded.json")) }
  #let(:order_fulfilled) { File.read(Rails.root.join("spec", "fixtures", "shopify", "order_fulfilled.json")) }
  let(:hmac_header) { "dummy_hmac" }
  let(:order_fulfilled_customer_raw_post_data) { file_fixture('shopify/order_fulfilled_customer.json').read }

  # let(:created_parsed_data) { JSON.parse(created_raw_post_data, symbolize_names: true) }
  # let(:deleted_raw_post_data) { file_fixture('shopify/user_deleted.json').read }

  before do
    WebMock.disable_net_connect!(allow_localhost: true)
    stub_request(:post, ENV['SLACK_WEBHOOK_URL'])
      .to_return(status: 200)
    request.headers["HTTP_X_SHOPIFY_HMAC_SHA256"] = hmac_header
    request.headers["Content-Type"] = "application/json"
    allow(controller).to(receive(:verify_webhook).and_return(true))
  end

  describe 'POST #fulfill' do
  #   context 'with valid data' do
  #     it 'creates a new user' do
  #       expect {
  #         post(:create, body: user_created)
  #       }.to(change(User, :count).by(1))
  #
  #       user_json = JSON.parse(user_created, symbolize_names: true)
  #       expect(response).to(have_http_status(:ok))
  #       user_last = User.last
  #       expect(user_last.email).to(eq(user_json[:email]))
  #       expect(user_last.address_1).to(eq(user_json[:default_address][:address1]))
  #       expect(user_last.phone).to(eq(user_json[:default_address][:phone]))
  #       expect(user_last.shopify_id).to(eq(user_json[:id].to_s))
  #       expect(user_last.phone_prefix).to(eq(27))
  #     end
  #
  #     it 'enqueues a slack notification for user' do
  #       expect {
  #         post(:create, body: user_created)
  #       }.to(change(SlackNotificationJob.jobs, :size).by(1))
  #     end
  #
  #     it 'updates existing user shopify_id' do
  #       user_json = JSON.parse(user_created, symbolize_names: true)
  #       user = create(:user, email: user_json[:email])
  #
  #       expect {
  #         post(:create, body: user_created)
  #       }.not_to(change(User, :count))
  #
  #       expect(user.reload.shopify_id).to(eq(user_json[:id].to_s))
  #       expect(response).to(have_http_status(:ok))
  #     end
  #   end
  #
  #   context 'with invalid data' do
  #     it 'returns bad request for invalid JSON' do
  #       post :create, body: 'invalid json'
  #       expect(response).to(have_http_status(:bad_request))
  #     end
  #   end

    context 'with invalid JSON' do
      it 'returns bad request' do
        post :fulfill, body: 'invalid json'
        expect(response).to(have_http_status(:bad_request))
      end
    end

    context 'with unfulfilled order' do
      let(:unfulfilled_webhook) do
        {
          id: '123',
          fulfillment_status: 'unfulfilled',
          email: 'test@example.com'
        }.to_json
      end

      it 'returns ok without creating order' do
        expect {
          post(:fulfill, body: unfulfilled_webhook)
          }.not_to(change(Order, :count))
          expect(response).to(have_http_status(:ok))
      end
    end

    context 'without customer data' do
      let(:order_fulfilled_no_customer_raw_post_data) { file_fixture('shopify/order_fulfilled.json').read }

      it 'creates order with email only user' do
          expect { post(:fulfill, body: order_fulfilled_no_customer_raw_post_data) }
            .to(change(Order, :count).by(1))
            .and(change(User, :count).by(1))
            .and(change(SlackNotificationJob.jobs, :size).by(1))

          user = User.last
          expect(user.email).to(eq('hello@fresh.com'))
          expect(user.shopify_id).to(be_nil)

          # expect {
          #   post(:create, body: order_fulfilled_no_customer_raw_post_data)
          # }

          last_job = SlackNotificationJob.jobs.last
          expect(last_job["args"]).to(eq([ "User created without ShopifyID hello@fresh.com" ]))
      end
    end

          #   it 'uses existing user if found by email' do
          #     existing_user = create(:user, email: 'hello@fresh.com')
          #
          #     expect {
          #       post(:fulfill, body: webhook_without_customer, headers: valid_headers)
          #     }.to(change(Order, :count).by(1)
          #                               .and(not_change(User, :count)))
          #
          #     expect(existing_user.reload.shopify_id).to(be_nil)
          #   end
          # end




#
#     context 'with fulfilled order' do
#       let(:webhook_with_customer) { file_fixture('fulfilled_order_with_customer.json').read }
#       let(:webhook_without_customer) { file_fixture('fulfilled_order_without_customer.json').read }
#
#       context 'with customer data' do
#         it 'creates order and user with full details' do
#           expect {
#             post(:fulfill, body: webhook_with_customer, headers: valid_headers)
#           }.to(change(Order, :count).by(1)
#                                     .and(change(User, :count).by(1)))
#
#           user = User.last
#           expect(user.email).to(eq('john@example.com'))
#           expect(user.shopify_id).to(eq('115310627314723954'))
#           expect(user.address_1).to(eq('123 Elm St.'))
#
#           order = Order.last
#           expect(order.product_type).to(eq('02'))
#           expect(order.quantity).to(eq(5))
#           expect(order.order_status).to(eq('fulfilled'))
#           expect(order.user_id).to(eq(user.id))
#
#           expect(slack_job).to(have_received(:perform_async)
#                                  .with('User created in Shopify: john@example.com'))
#         end
#
#         it 'updates existing user if found' do
#           existing_user = create(:user, email: 'john@example.com')
#
#           expect {
#             post(:fulfill, body: webhook_with_customer, headers: valid_headers)
#           }.to(change(Order, :count).by(1)
#                                     .and(not_change(User, :count)))
#
#           expect(existing_user.reload.shopify_id).to(eq('115310627314723954'))
#         end
#       end
#
#
#
#       context 'without customer and email' do
#         it 'creates order without user' do
#           webhook_data = JSON.parse(webhook_without_customer)
#           webhook_data['email'] = nil
#
#           expect {
#             post(:fulfill, body: webhook_data.to_json, headers: valid_headers)
#           }.to(change(Order, :count).by(1)
#                                     .and(not_change(User, :count)))
#
#           expect(Order.last.user_id).to(be_nil)
#           expect(slack_job).to(have_received(:perform_async)
#                                  .with("Order fulfilled without a customer and email #{webhook_data['id']}"))
#         end
#       end
#
#       context 'with invalid order data' do
#         before do
#           allow_any_instance_of(Order).to(receive(:save).and_return(false))
#         end
#
#         it 'returns unprocessable_entity' do
#           post :fulfill, body: webhook_with_customer, headers: valid_headers
#           expect(response).to(have_http_status(:unprocessable_entity))
#         end
#       end
#     end
#   end
  end
end