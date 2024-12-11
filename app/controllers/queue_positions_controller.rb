class QueuePositionsController < ApplicationController
  def create
    @concert = Concert.find(params[:concert_id])
    @queue_position = QueuePosition.create!(
      concert: @concert,
      user_token: SecureRandom.uuid,
      status: 'waiting'
    )
    redirect_to queue_status_path(@queue_position)
  end

  def status
    @position = QueuePosition.find_by!(user_token: params[:token])
  end
end