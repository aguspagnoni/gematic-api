class Forest::PriceList
  include ForestLiana::Collection

  collection :price_lists
  action 'Autorizar'
  action 'Descargar TXT'
end
