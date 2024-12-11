class ReservationsController < ApplicationController
  before_action :set_concert
  before_action :check_availability
  before_action :check_session_expiry, only: [:create]

  def new
    @reservation = @concert.reservations.new
  end

  def create
    @reservation = @concert.reservations.new(reservation_params)
    @reservation.expires_at = 5.minutes.from_now

    if @reservation.save
      @concert.decrement!(:available_tickets, reservation_params)
      redirect_to success_path
    else
      render :new
    end
  end

  private

  def check_availability
    redirect_to sold_out_path if @concert.available_tickets.zero?
  end

  def check_session_expiry
    redirect_to queue_path(@concert) if session[:reservation_expires_at] < Time.current
  end

  def set_concert
    @concert = Concert.find(params[:concert_id])
  end

  def reservation_params
    params.require(:reservation).permit(:quantity)
  end
end