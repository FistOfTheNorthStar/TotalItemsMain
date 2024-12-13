class QueuePositionsController < ApplicationController
  def ping
  end

  def status
    @reservation = Reservation.find(params[:reservation_id])
    @position = QueuePosition.create!(
      concert_id: @reservation.concert.id,
      reservation_id: @reservation.id,
      user_token: SecureRandom.uuid,
      status: "waiting",
      position: QueuePosition.where(concert: @concert, expires_at: Time.current..(5.minutes + 5.seconds).from_now).count + 1,
      expires_at: @reservation.expires_at + 5.seconds.from_now
    )
  end
end
