class Forest::Order
  include ForestLiana::Collection

  collection :orders

  action 'Ver Resumen Pedido'
  action 'Duplicar Pedido'
  action 'Cargar Productos desde Lista'
end
