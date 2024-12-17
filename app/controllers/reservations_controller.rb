class ReservationsController < ApplicationController
  before_action :set_item, only: [ :new ]
  before_action :set_reservation, only: [ :create ]
  before_action :check_availability
  before_action :check_new_expiration, only: [ :new ]
  before_action :check_create_expiration, only: [ :create ]

  def new
    session[:reservation_id] = @reservation.id
    check_queue
  end

  def create
    unless session && @reservation
      redirect_to(root_path, alert: "Please start from the beginning")
      return
    end
    if @reservation.status == "reserved"
      reset_session
      redirect_to(root_path, alert: "Trying to re-reserve same session, please try again.")
      return
    end

    ## PAYMENT FLOW

    quantity = reservation_params[:quantity].to_i
    if quantity <= @item.available_items && @reservation.status == "pending" && !@reservation.expired?
      ActiveRecord::Base.transaction do
        @reservation.update!(status: :reserved, quantity:)
        @reservation.item.decrement!(:available_items, quantity)
      end
      reset_session
      redirect_to(root_path, notice: "#{ShareVariablesConstantsRegex::REPLACE_THIS}: Successful reservation")
      return
    end

    render(:new, status: :unprocessable_entity)
  end

private

  def check_availability
    @item||=@reservation.concert
    if @item.available_items.zero?
      reset_session
      redirect_to(item_path(item), alert: "Sold out sorry!")
    end
  end

  def set_item
    @item = Item.find(params[:item_id])
  end

  def set_reservation
    @reservation = Reservation.find(reservation_params[:reservation_id])
  end

  def check_queue
    if queue_required?

      redirect_to(url_for(controller: "queue_positions", action: "status", item_id: @reservation.item_id,
reservation_id: @reservation.id))
    end
  end


  def check_new_expiration
    reservations = @concert.reservations
    if (reservation_id = session[:reservation_id])
      @reservation = reservations.find(reservation_id)

      if @reservation&.expired?
        reset_session
        redirect_to(concert_path(@concert), alert: "Reservation session has expired")
      end
    else
      uuid=SecureRandom.uuid
      expires_at=Time.current+5.minutes
      @reservation = reservations.create(quantity: 0, expires_at:, status: :pending, uuid:)
    end
  end

  def check_create_expiration
    redirect_to(concert_path(@concert), alert: "Reservation session has expired") if @reservation.expired?
  end

  def queue_required?
    @concert.reservations.pending_and_expiring_soon.count > 10 || @concert.queue_positions.expiring_soon.count > 0
  end

  def reservation_params
    params.require(:reservation).permit(:quantity, :reservation_id)
  end
end
