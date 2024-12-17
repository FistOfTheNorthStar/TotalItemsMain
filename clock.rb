require "clockwork"

require_relative "./config/boot"
require_relative "./config/environment"

module Clockwork
  every 15.minutes, "quarterhourly.ticket_retruner" do
    UpdateListingPricesJob.perform_later
  end
end
