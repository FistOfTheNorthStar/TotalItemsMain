class ReservationProcessingJob
  include Sidekiq::Job
  sidekiq_options retry: ShareVariablesConstantsRegex::PAYMENT_JOB_RETRIES, retry_for: ShareVariablesConstantsRegex::PAYMENT_JOB_EXPIRES

  class ReservationJobError < StandardError; end

  def perform(reservation_id, uuid)
    ActiveRecord::Base.transaction do
      begin
        reservation = Reservation.find(reservation_id)
        if reservation.uuid != uuid
          raise ReservationJobError, "Reservation #{uuid} not matching"
        end

        # MISSING PAYMENT LOGIC GOES HERE

      rescue ActiveRecord::RecordNotFound => e
        raise ReservationJobError, "Reservation #{reservation_id} not found"
      rescue => e
        raise ReservationJobError, "Transaction failed: #{e.message}"
      end
    end
  end

  sidekiq_retries_exhausted do |job, _ex|
    job_args = job["args"]
    Sidekiq.logger.warn "Failed #{job['class']} with #{job_args}: #{job['error_message']}"
    reservation_id = job_args[0]
    set_ticket_available_again(reservation_id)
  end

  private

  def set_ticket_available_again(reservation_id)
    Reservation.update(reservation_id)
    reservation = Reservation.find(reservation_id)
    reservation.item.increment!(:available_tickets, reservation.quantity) # put tickets back
    reservation.update(status: "expired_or_error")
  end
end
