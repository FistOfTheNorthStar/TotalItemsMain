require "clockwork"

require_relative "./config/boot"
require_relative "./config/environment"

module Clockwork
  every 15.minutes, "quarterhourly.tree_allocation" do
  end
end
