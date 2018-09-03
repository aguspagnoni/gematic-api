class Forest::PriceList
  include ForestLiana::Collection

  collection :price_lists

  action 'Autorizar'
  action 'Duplicar Lista'
  action 'Ver Resumen Lista', download: true
end
