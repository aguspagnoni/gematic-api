class Forest::PriceList
  include ForestLiana::Collection

  collection :price_lists

  action 'Autorizar'
  action 'Ver Resumen Lista', download: true
end
