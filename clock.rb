require "clockwork"

require_relative "./config/boot"
require_relative "./config/environment"

module Clockwork
  # every 15.minutes, "quarterhourly.tree_allocation" do
  # end

  every(1.day, 'process_orders.daily', at: '07:00') do
    ProcessOrdersJob.perform_async
  end
end
