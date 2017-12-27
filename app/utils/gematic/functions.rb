module Utils
  module Gematic::Functions

    def self.duplicate_order(original_order)
      order = Order.new(company: original_order.company,
                        branch_office: original_order.branch_office,
                        name: "Copia de Pedido Numero #{original_order.id} #{original_order.name}")
      original_order.order_items.each do |order_item|
        order.order_items << OrderItem.new(product: order_item.product, quantity: order_item.quantity)
      end
      order.save!
    end

    def self.populate_order_with_price_list(order)
      price_list = order.custom_price_list || PriceList.for_company(order.company)
      price_list.products.each do |product|
        new_item = OrderItem.new(product: product,
                                 quantity: 0,
                                 order: order)
        order.order_items << new_item
      end
      order.save!
    end
  end
end
