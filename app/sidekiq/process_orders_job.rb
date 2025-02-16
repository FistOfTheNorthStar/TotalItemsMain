class ProcessOrdersJob
    include Sidekiq::Job
  
    sidekiq_options queue: :default, retry: 3
  
    def perform
      # Find all unprocessed orders that are fulfilled
      unprocessed_orders = Order.where(order_processed: false, order_status: :fulfilled)
      
      unprocessed_orders.find_each do |order|
        AllocateTreesJob.perform_async(order.id)
      end
  
      SlackNotificationJob.perform_async(
        "ProcessOrdersJob: Enqueued #{unprocessed_orders.count} orders for tree allocation"
      )
    end
  end