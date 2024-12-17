class ReservationExpirationCleanupJob
  include Sidekiq::Job
  class ReservationExpirationCleanupJobError < StandardError; end

  def perform(reservation_id)
    ActiveRecord::Base.transaction do
      begin
        reservation = Reservation.find(reservation_id)
        if reservation.uuid != uuid
          raise(ReservationExpirationCleanupJobError, "Reservation #{uuid} not matching")
        end

        # MISSING PAYMENT LOGIC GOES HERE

      rescue ActiveRecord::RecordNotFound => e
        raise(ReservationExpirationCleanupJobError, "Reservation #{reservation_id} not found")
      rescue => e
        raise(ReservationExpirationCleanupJobError, "Transaction failed: #{e.message}")
      end
    end
  end
end
