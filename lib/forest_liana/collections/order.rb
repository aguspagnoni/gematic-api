class Forest::Order
  include ForestLiana::Collection

  collection :orders

  action 'Ver Pedido'
  action 'Autorizar Pedido'
  action 'Duplicar Pedido'
  action 'Cargar Productos desde Lista'
end
