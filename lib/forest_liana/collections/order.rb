class Forest::Order
  include ForestLiana::Collection

  collection :orders

  action 'Ver Pedido por mail'
  action 'Autorizar Pedido'
  action 'Descargar Pedido', download: true
  action 'Duplicar Pedido'
  action 'Cargar Productos desde Lista'
end
