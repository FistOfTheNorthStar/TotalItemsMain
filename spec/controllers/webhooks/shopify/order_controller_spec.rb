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

      it 'creates order and user with only email' do
          expect { post(:fulfill, body: order_fulfilled_no_customer_raw_post_data) }
            .to(change(Order, :count).by(1)
            .and(change(User, :count).by(1)
            .and(change(SlackNotificationJob.jobs, :size).by(2))))

          expect(response).to(have_http_status(:ok))

          user = User.last
          expect(user.email).to(eq('hello@fresh.com'))
          expect(user.shopify_id).to(eq(""))

          order = Order.last
          expect(order.product_type).to(eq("02"))
          expect(order.quantity).to(eq(5))

          last_jobs = SlackNotificationJob.jobs.last(2)
          expect(last_jobs[0]["args"]).to(eq([ "User created without ShopifyID hello@fresh.com" ]))
          expect(last_jobs[1]["args"]).to(eq([ "Order fulfilled: hello@fresh.com, id 6683595997448, sku 02" ]))
      end

      context 'with an existing customer' do
        it 'creates order with customer' do
          create(:user, email: 'hello@fresh.com')

          expect {
            post(:fulfill, body: order_fulfilled_no_customer_raw_post_data)
          }.to(change(Order, :count).by(1)
           .and(not_change(User, :count)))

          expect(response).to(have_http_status(:ok))
        end
      end
    end

    context 'with customer data in payload' do
      let(:order_fulfilled_customer_raw_post_data) { file_fixture('shopify/order_fulfilled_customer.json').read }

      context 'without existing customer' do
        it 'creates order and customer' do
          expect { post(:fulfill, body: order_fulfilled_customer_raw_post_data) }
            .to(change(Order, :count).by(1)
            .and(change(User, :count).by(1)
            .and(change(SlackNotificationJob.jobs, :size).by(2))))

          expect(response).to(have_http_status(:ok))

          user = User.last
          expect(user.email).to(eq('john@example.com'))
          expect(user.shopify_id).to(eq("115310627314723954"))

          order = Order.last
          expect(order.product_type).to(eq("02"))
          expect(order.quantity).to(eq(5))

          last_jobs = SlackNotificationJob.jobs.last(2)
          expect(last_jobs[0]["args"]).to(eq([ "User created in Shopify: john@example.com, 115310627314723954" ]))
          expect(last_jobs[1]["args"]).to(eq([ "Order fulfilled: john@example.com, id 6683595997448, sku 02" ]))
        end
      end
    end

    context 'with an existing customer' do
      it 'creates order' do
        create(:user, email: 'john@example.com')

        expect {
          post(:fulfill, body: order_fulfilled_customer_raw_post_data)
        }.to(change(Order, :count).by(1)
         .and(not_change(User, :count)))

        expect(response).to(have_http_status(:ok))
      end
    end
  end
end
