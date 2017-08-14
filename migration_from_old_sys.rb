require 'csv'
crudo = CSV.read('/Users/agustinpagnoni/Downloads/LISTA_CLIENTES_GEMATIC_editado.csv', { headers: true, header_converters: :symbol, encoding: 'windows-1252:UTF-8' })
crudo_h = crudo.map(&:to_hash);nil
companies_info = crudo_h.reject { |k| k[:nombre].blank? }.group_by {|k| k[:nombre] };nil
by_cuit = crudo_h.reject { |k| k[:cuit].blank? }.group_by {|k| k[:cuit] }.select { |name, arr| arr.size > 1 };nil
# ["ACOTEC S.A.", [{:numero=>"151", :nombre=>"ACOTEC S.A.", :cuit=>"30-66105837-0", :posicion=>"RI", :domicilio=>"Cespedes 2869", :cod_postal=>"0", :localidad=>"V. adelina", :provincia=>"bs as", :telefono=>nil, :cuenta=>"121340", :clasif=>"902", :ultvtafech=>"05-Jul-17", :ultmovfech=>"28-Jul-17", :ultmovcomp=>"RCX", :ultcobfech=>"28-Jul-17", :listapre=>"Acotec", :iva=>nil, :agente_ret=>nil, :contacto=>nil, :email=>nil, :forma_pago=>"0", :descuento=>"0", :ocasional=>"FALSE", :pagoefecti=>"FALSE", :pagoctacte=>"FALSE", :pagocheque=>"FALSE", :restpagos=>"FALSE", :limitevenc=>"0", :vigen_cuit=>"02-Jan-09", :fantasia=>"ACOTEC S.A.", :lunes=>"TRUE", :martes=>"TRUE", :miercoles=>"TRUE", :jueves=>"TRUE", :viernes=>"TRUE", :sabado=>"TRUE", :domingo=>"TRUE"}]]


to_reject = ['CANTERAS CERRO NEGRO SA', 'ALEJANDRO LOMBA TABOADA', 'BENAVIDEZ Mariana', 'FEDERICO COYA', 'GABRIEL PAGNONI', 'CREADO ELSA LAURA', 'SARAVIA PAULA', 'ELS LENGUAGE CENTERS', 'UCA AGRARIAS', 'IZON ARIEL', 'MANUEL TIENDA LEON S.A.', 'S & M INTERNATIONAL SA', 'VIA NET WORKSARG SA', 'SANTA RITA MEDICINA', 'SOC. DE INVERSION']
companies_info.each do |name, arr_of_hash|
  if to_reject.include?(name)
    next
  end
  h = arr_of_hash.first
  company      = Company.find_by(name: name.capitalize)
  puts "company not found: #{name.capitalize}" if company.nil?
  next if company.nil?
  address      = h[:domicilio]
  cuit         = h[:cuit]
  iva          = h[:iva] == 'S' ? 'si' : 'no'
  provincia    = h[:provincia]
  localidad    = h[:localidad]
  zipcode      = h[:cod_postal]
  condition    = "#{h[:posicion]} - IVA: #{iva}"

  razon_social = h[:nombre]
  BillingInfo.create(address: address, cuit: cuit, condition: condition,
                     razon_social: razon_social, company_id: company.id,
                     localidad: localidad, province: provincia, zipcode: zipcode, phone: h[:telefono],
                     other_info: "cuenta: #{h[:cuenta]} - clasif: h[:clasif] - listapre: h[:listapre]")
  BranchOffice.create(company: company, name: address, address: address, zipcode: zipcode)
end
#=> BillingInfo(id: integer, address: string, cuit: string, condition: string, razon_social: string, company_id: integer, created_at: datetime, updated_at: datetime)

f = File.open('/Users/agustinpagnoni/Downloads/LISTADO_STOCK_GEMATIC.csv', 'r')
contents = f.read

# => {:despacho=>nil, :exp_2=>"0", :exp_3=>"0", :cantidad=>"-702", :deposito=>"1", :codigo=>"7798065730330",
# :descripcio=>"sierra de los padres naranja x500", :costo=>"6.6", :precio_uni=>"0", :cantidad2=>"0",
# :cant_pendi=>"0", :cant_pedid=>"0", :cantped_et=>"0", :cantped2et=>"0", :cant_pend2=>"0", :ult_vta=>"  -   -",
# :ult_prec_v=>"0", :cod_subrub=>"13", :clasif=>"0", :fraccion=>"sierra de los padres naranja x500",
# :cod_rubro=>"1", :des_rubro=>"Almacen", :numero=>"1", :nombre=>"Almacen", :depnombre=>"Dep 1", :bodeganomb=>"Bodega 1"}

require 'csv'
productos = CSV.read('/Users/agustinpagnoni/Downloads/listado_stock_ok.csv', { headers: true, header_converters: :symbol, encoding: 'windows-1252:UTF-8' })
productos_h = productos.map(&:to_hash);nil

productos_h.each do |h|
  begin
    cat         = Category.find_by(name: h[:des_rubro])
    cost        = h[:costo].to_f == 0 ? 99999 : h[:costo].to_f
    gross_price = cost * 1.5
    next if Product.find_by(name: h[:descripcio], code: h[:codigo])
    desc = h[:descripcio].blank? ? 'PRODUCTO SIN NOMBRE' : h[:descripcio]
    code = h[:codigo].blank? ? 'SIN CODIGO' : h[:codigo]
    prod = Product.create(name: desc, code: code, cost: cost.round(2), gross_price: gross_price.round(2))
    cat.products << prod
  rescue => e
    byebug
    puts e
    next
  end
end


productos_h.group_by {|k| k[:des_rubro]}.map(&:first).each do |cat|
  Category.create(name: cat)
end
# Almacen, 694
# Cafes, 39
# Servicios, 183
# VENDING, 11
# Bebidas, 85
# LIMPIEZA, 28
# SNACKS, 33
# DESCARTABLES, 12
# Tarjetas, 3

productos = CSV.read('/Users/agustinpagnoni/Downloads/LISTA_DE_PRECIOS_GEMATIC.csv', { headers: true, header_converters: :symbol, encoding: 'windows-1252:UTF-8' })
productos_h = productos.map(&:to_hash);nil


productos_h.group_by {|k| k[:nom_rubro]}.map(&:first).each do |cat|
  Category.create(name: cat)
end

asd = productos_h.group_by {|k| k[:nom_rubro]}.map {|k, v| { cat: k, subs: v.map {|g| g[:nomsubrubr]}.uniq} }

cats = [
{:cat=>"Almacen", :subs=>["Snacks", "Aderezos", "Descartables", "Infusiones", "Endulzantes", "Leches", "Limpieza", "Yerba Mate"]},
{:cat=>"Servicios", :subs=>["Repuestos"]},
{:cat=>"Bebidas", :subs=>["Gaseosas", "Aguas Saborizadas", "Jugos"]},
{:cat=>"Cafes", :subs=>["Tostado", "Elaboracion Propia", "Grano Crudo", "Vending"]}]

cats.each do |h|
  cat = Category.find_by(name: h[:cat])
  h[:subs].each do |h2|
    Category.create(name: h2, supercategory: cat)
  end
end






