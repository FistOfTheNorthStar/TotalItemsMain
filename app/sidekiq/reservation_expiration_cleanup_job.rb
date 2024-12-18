class ReservationExpirationCleanupJob
  include Sidekiq::Job

  def perform
    expired_quantities = Reservation.pending_and_old
    expired_quantities.group(:item_id)
      .sum(:quantity).each do |item_id, total_quantity|
      item = Item.find(item_id)
      item.increment!(:available_items, total_quantity) if item
    end
    expired_quantities.update_all(status: :expired)
  end
end
