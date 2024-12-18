class ReservationProcessingJob
  include Sidekiq::Job
  sidekiq_options retry: ShareVariablesConstantsRegex::PAYMENT_JOB_RETRIES,
    retry_for: ShareVariablesConstantsRegex::PAYMENT_JOB_EXPIRES

  class ReservationJobError < StandardError; end

  def perform(reservation_id)
    ActiveRecord::Base.transaction do
      begin
        reservation = Reservation.find(reservation_id)

        # Payment logic is lacking but we just want to send notifications to the front of state chagnes
        reservation.payment_begin!
        # MISSING PAYMENT LOGIC GOES HERE
        # Let's just wait for now
        if Rails.env.test? && ENV["TEST_WAIT"]
          sleep(ENV["TEST_WAIT"].to_i) # Emulate 2-second API delay
        end

        reservation.completed!

      rescue ActiveRecord::RecordNotFound => error
        # Let job finish here, log the error
        Rails.logger.error("Could not find reservation: #{error.message}")
      rescue => error
        raise(ReservationJobError, "Job with reservation_id: #{reservation_id} with #{error.message}")
      end
    end
  end

  sidekiq_retries_exhausted do |job, _ex|
    job_args = job["args"]
    Sidekiq.logger.warn("Failed #{job['class']} with #{job_args}: #{job['error_message']}")
    reservation_id = job_args[0]
    set_ticket_available_again(reservation_id)
  end

  private

  def set_ticket_available_again(reservation_id)
    Reservation.find(reservation_id)
    reservation = Reservation.find(reservation_id)
    reservation.item.increment!(:available_tickets, reservation.quantity) # put tickets back
    reservation.update(status: "expired_or_error")
  end
end
