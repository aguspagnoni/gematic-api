class Forest::Discount
  include ForestLiana::Collection

  collection :discounts

  field :price_today, type: 'Float' do
    object.calculate_price_now
  end
end
