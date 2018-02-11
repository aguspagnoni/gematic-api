class Forest::OrderItemsController < Forest::GematicBaseController
  def change_quantity
    order_items.each do |order_item|
      order_item.update!(quantity: new_quantity)
    end
  end

  private

  def order_items
    ::OrderItem.where(id: params[:data][:attributes][:ids])
  end

  def new_quantity
    params[:data][:attributes][:values][:quantity]
  end
end
