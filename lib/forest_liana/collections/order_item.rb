class Forest::OrderItem
  include ForestLiana::Collection

  collection :OrderItem

  action 'Cambiar cantidad', fields: [{
    field: 'quantity',
    type: 'Number',
    description: 'Nueva Cantidad (sin decimal)',
    isRequired: true
  }]
end
