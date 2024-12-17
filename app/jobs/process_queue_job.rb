class ProcessQueueJob < ApplicationJob
  queue_as :default

  def perform(item_id)
    item = Item.find(item_id)
    return if item.available_items.zero?

    next_in_queue = QueuePosition.where(item: item, status: "waiting")
                                 .order(created_at: :asc)
                                 .first

    return unless next_in_queue

    next_in_queue.update!(status: "ready")
    # Schedule next queue processing
    ProcessQueueJob.set(wait: 5.minutes).perform_later(item_id)
  end
end
