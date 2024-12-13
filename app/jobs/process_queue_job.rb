class ProcessQueueJob < ApplicationJob
  queue_as :default

  def perform(concert_id)
    concert = Concert.find(concert_id)
    return if concert.available_tickets.zero?

    next_in_queue = QueuePosition.where(concert: concert, status: "waiting")
                                 .order(created_at: :asc)
                                 .first

    return unless next_in_queue

    next_in_queue.update!(status: "ready")
    # Schedule next queue processing
    ProcessQueueJob.set(wait: 5.minutes).perform_later(concert_id)
  end
end
