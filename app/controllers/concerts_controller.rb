class ConcertsController < ApplicationController

  def index
    @concerts = Concert.all
  end

  def show
    @concert = Concert.find(params[:id])
    redirect_to queue_path(@concert) if queue_required?
  end

  private

  def queue_required?
    # Simple logic: if more than 10 active sessions, enable queue
    Reservation.where(concert: @concert, status: 'active').count > 10
  end
end