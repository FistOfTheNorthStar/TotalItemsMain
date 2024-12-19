class ReservationCleanupWithoutItemJob

  # Not ran often
  def perform
    begin
      orphaned_reservations = Reservation.where.missing(:item)
      count = orphaned_reservations.count

      orphaned_reservations.in_batches(of: 1000) do |batch|
        batch.destroy_all
      end

      Rails.logger.info("Deleted #{count} reservations without associated items")
    rescue => e
      Rails.logger.error("ReservationCleanupWithoutItemJob failed: #{e.message}")
      raise(e)
    end
  end
end
