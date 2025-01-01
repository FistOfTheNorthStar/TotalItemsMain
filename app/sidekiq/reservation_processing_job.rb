# class ReservationProcessingJob
#   require "action_cable/engine"
#   include Sidekiq::Job
#   sidekiq_options retry: ShareVariablesConstantsRegex::PAYMENT_JOB_RETRIES,
#     retry_for: ShareVariablesConstantsRegex::PAYMENT_JOB_EXPIRES
#
#   class ReservationProcessingJobError < StandardError; end
#
#   def perform(reservation_id)
#     begin
#       reservation = Reservation.find(reservation_id)
#       sleep_time = (Rails.env.test? || Rails.env.development?) && (wait = ENV["TEST_WAIT"]) ? wait : 2
#       sleep(sleep_time)
#
#       # Payment logic is lacking but we just want to send notifications to the front of state chagnes
#       reservation.payment_begin!
#
#       sleep(sleep_time)
#       reservation.completed!
#     rescue ActiveRecord::RecordNotFound => error
#       # Let job finish here, log the error
#       Rails.logger.error("Could not find reservation: #{error.message}")
#     rescue => error
#       raise(ReservationProcessingJobError, "Job with reservation_id: #{reservation_id} with #{error.message}")
#     end
#   end
#
#   sidekiq_retries_exhausted do |job, _ex|
#     job_args = job["args"]
#     Sidekiq.logger.warn("Failed #{job['class']} with #{job_args}: #{job['error_message']}")
#     reservation_id = job_args[0]
#     set_items_available_again(reservation_id)
#   end
#
#   private
#
#   def set_items_available_again(reservation_id)
#     reservation = Reservation.find(reservation_id)
#     Reservation.transaction do
#       reservation.item.increment!(:available_items, reservation.quantity)
#       reservation.update!(status: :failed)
#     end
#   end
# end
