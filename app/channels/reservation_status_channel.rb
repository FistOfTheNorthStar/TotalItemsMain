class ReservationStatusChannel < ApplicationCable::Channel
  def subscribed
    if params[:reservation_id]
      stream_from("reservation_status_channel_#{params[:reservation_id]}")
    else
      reject
    end
  end

  def unsubscribed
  end
end
