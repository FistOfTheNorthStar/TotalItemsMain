class ItemsController < ApplicationController
  def index
    @items = items
  end

  def show
    @item = items.find(params[:id])
  end

  private
  def items
    @items ||= Item.sellable_items
  end
end
