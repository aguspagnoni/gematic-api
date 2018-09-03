module Utils
  module Gematic::Functions

    def self.duplicate_order(original_order)
      order = Order.new(company: original_order.company,
                        branch_office: original_order.branch_office,
                        custom_price_list: original_order.custom_price_list,
                        seller_company: original_order.seller_company,
                        name: "Copia de Pedido Numero #{original_order.id} #{original_order.name}")
      original_order.order_items.each do |order_item|
        order.order_items << OrderItem.new(product: order_item.product, quantity: order_item.quantity)
      end
      order.save!
    end

    def self.populate_order_with_price_list(order, price_list)
      price_list.products.each do |product|
        new_item = OrderItem.new(product: product,
                                 quantity: 0,
                                 order: order)
        order.order_items << new_item
      end
      order.save!
    end

    def self.duplicate_list(original_list)
      new_list = original_list.dup
      new_list.name = 'Copy of ' + new_list.name
      new_list.authorized_at = nil
      new_list.authorizer_id = nil
      original_list.discounts.each do |original_discount|
        new_discount = original_discount.dup
        new_discount.price_list = new_list
        new_list.discounts << new_discount
      end
      new_list.save
    end
  end
end
