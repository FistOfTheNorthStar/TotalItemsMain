class ReservationStatusBroadcaster
  include Rails.application.routes.url_helpers
  attr_accessor :reservation_id, :status

  class ReservationStatusBroadcasterError < StandardError; end

  def initialize(reservation_id, status)
    @reservation_id = reservation_id
    @status = status
    @redirect_to = nil
    @broadcast_message = nil
  end

  def channel
    "reservation_status_channel_#{@reservation_id}"
  end

  def broadcast
    return if @status.blank? || @status=="pending"
    status_processor
    payload = {
      status: @status,
      message: @broadcast_message,
      redirect_to: nil
    }
    payload.merge!(redirect_to: @redirect_to) if @redirect_to
    ActionCable.server.broadcast(channel, payload)
  end

  def status_processor
    case @status
    when "pending"
      # No need to broadcast this
      @broadcast_message="Pending"
    when "payment_begin"
      @broadcast_message="Payment initiated"
    when "payment_end"
      "Payment completed"
    when "canceled"
      "Reservation canceled"
    when "expired"
      "Reservation expired"
    when "failed"
      @redirect_to="/items"
      @broadcast_message="Reservation failed, please try again"
    when "completed"
      @redirect_to="/"
      @broadcast_message="Reservation completed successfully"
    else
      # Better to raise an error if status doesn't exist
      raise(ReservationStatusBroadcasterError, "Status unknown")
    end
    end
end
