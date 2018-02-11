class Forest::PriceListsController < Forest::GematicBaseController
  def change_quantity
    order_item.update!(quantity: new_quantity)
  end

  private

  def order_item
    OrderItem.where(id: params[:data][:attributes][:ids]).first
  end

  def new_quantity
    params[:data][:attributes][:values][:quantity]
  end
end
