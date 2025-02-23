class AllocateTreesJob
    include Sidekiq::Job

    sidekiq_options queue: :default, retry: 3
  
    def perform(order_id)
      order = Order.find_by(id: order_id)
      return unless order
  
      begin
        ActiveRecord::Base.transaction do
          trees_to_allocate = order.quantity.floor # Only allocate whole trees
  
          trees_to_allocate.times do
            create_tree_for_order(order)
          end
  
          # If there are fractional credits, they remain in the user's balance
          order.update!(order_processed: true)
  

          SlackNotificationJob.perform_async(
            "AllocateTreesJob: Allocated #{trees_to_allocate} trees for Order ##{order.id} (User: #{order.user.email})"
          )
        end
      rescue => e
        SlackNotificationJob.perform_async(
          "AllocateTreesJob Error: Failed to allocate trees for Order ##{order.id} - #{e.message}"
        )
        raise
      end
    end

    private

    def create_tree_for_order(order)
      Tree.create!(
        user: order.user,
        tree_type: order.tree_type,
        tree_state: :reserved,
        price: 0, # Since this is from subscription
        currency: 0, # Default currency
        tax: 0,
        tax_percentage: 0,
        tax_inclusive: true,
        tree_code: generate_tree_code,
        tree_batch: current_tree_batch
      )
    end

    def generate_tree_code
      # Generate a unique 8-character code
      loop do
        code = SecureRandom.alphanumeric(8).upcase
        break code unless Tree.exists?(tree_code: code)
      end
    end

    def current_tree_batch
      # You might want to implement your own batch numbering logic
      Time.current.strftime("%Y%m").to_i
    end
end
