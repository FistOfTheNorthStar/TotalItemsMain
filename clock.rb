require "clockwork"

require_relative "./config/boot"
require_relative "./config/environment"

module Clockwork
  every 15.minutes, "quarterhourly.expire_reservations" do
    ReservationExpirationCleanupJob.perform_async
  end
end
