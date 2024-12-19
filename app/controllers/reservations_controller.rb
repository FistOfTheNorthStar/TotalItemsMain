class ReservationsController < ApplicationController
  before_action :set_item, only: [ :new, :create ]

  def new
    unless (@number_of_available_items =number_of_available_items) > 0
      redirect_to(root_path, alert: "Unfortunately sold out.")
    end
    @reservation = Reservation.new(item: @item)
  end

  def create
    quantity = reservation_params[:quantity].to_i
    @reservation=Reservation.new(item: @item)
    ActiveRecord::Base.transaction do
      # Lock the item to avoid race conditions
      @item.lock!
      available = number_of_available_items
      begin
        if available==0
          redirect_to(root_path, alert: "Sold out or zero quantity chosen!")
          return
        elsif quantity==0
          set_parameters_on_error(available, "zero quantity chosen!", :quantity)
        elsif quantity > available
          set_parameters_on_error(available, "exceeds available items", :quantity, available)
        end

        @item.decrement!(:available_items, quantity)
        @reservation.quantity = quantity
        @reservation.status = "pending"
        unless @reservation.save
          set_parameters_on_error(available, "exceeds available items", :base)
        end
      rescue => error
        set_parameters_on_error(available, "Could not complete reservation:  #{error.message}", :base)
      end

      p(@reservation.errors)
      # Check that email exists, whole customer creation will be moved to its own view and fixed with logic / social media logins
      # Customers will be forced to register or login via social media logins
      # Needs device
      unless reservation_params[:email] =~ URI::MailTo::EMAIL_REGEXP
        @reservation.errors.add(:email, "is not a valid email address")
      end

      raise(ActiveRecord::Rollback) if reservation_errors?
    end

    if reservation_errors?
      render(action: :new, status: 422)
      return
    end

    # Customer creation will later go into its own view, let's just take the email for now
    create_customer(reservation_params)

    ReservationProcessingJob.perform_in(10.seconds, @reservation.id)
    redirect_to(url_for(controller: "queue_positions", action: "status", item_id: @reservation.item_id,
                        reservation_id: @reservation.id))
  end

private

    def reservation_errors?
      @reservation.errors.any? || !@reservation.persisted?
    end

  # This is a temporary construct
  def create_customer(params)
    customer = Customer.build(email: params[:email])
    customer.shipping_address = params[:shipping_address] if params[:shipping_address].present?
    customer.phone = params[:phone] if params[:phone].present?
    customer.account = @reservation.account
    customer.save!
  end

  def number_of_available_items
    if (@availability =@item.availability)
      @item.reservation_limit ? [ @availability, @item.reservation_limit ].min : @availability
    else
      0
    end
  end

  def set_parameters_on_error(available, error_message, type, quantity = 1)
    @reservation.quantity = quantity
    @number_of_available_items = available
    @reservation.errors.add(type, error_message)
  end

  def set_item
    @item = Item.find(params[:item_id])
  end

  def check_still_available
    sellable_item
  end

  def reservation_params
    params.require(:reservation).permit(
      :quantity,
      :email,
      :phone,
      :reservation_id,
      :shipping_address
    )
  end
end
