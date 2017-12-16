require 'csv'
productos = CSV.read('/Users/agustinpagnoni/Downloads/LISTADO_STOCK_FASE_limpio.csv', { headers: true, header_converters: :symbol, encoding: 'windows-1252:UTF-8' })
productos_h = productos.map(&:to_hash);nil

not_found = productos_h.reject { |p| Product.find_by(code: p[:codigo]).present? };nil
not_found2 = not_found.reject { |p| Product.find_by(code: p[:codigo]&.strip&.downcase).present? };nil

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


def remove_left_0(source)
  start_index = 0
  while source[start_index] == '0'
    start_index += 1
  end
  source[start_index..-1]
end


SIN CODIGO, Alf Jorgelin Choc x 85 gr

Repetidos nueva tanda
---------
10, MUEBLE SOLISTA EQ  # => Product.find(727)
7, Caf? TORRADO molido 20 x 150 gr # => Product.find(860)
000009, coffe blen  passion en grano # => Product.find(405)
0000000000001, ALQUILER BEBEDERO DE AGUA # => Product.find(743)
00000000000024, DETERGENTE SYNTEX # => Product.find(745)
40197, disp toallas manos libres s 7 am blanco # => Product.find(428)


En la base ya repetidos si sacamos los 0s de adelante

without_0_all = codes.map {|c| remove_left_0(c) };nil
already_repeated = without_0_all.select { |x| without_0_all.select.count(x) > 1 } .uniq
codes.select {|c| already_repeated.any? {|c2| c =~ /^0+#{c2}$/}} # =>  ["00002", "00011", "00012", "000120", "000123"]
codes.select { |x| without_0_all.select.count(x) > 1 } .uniq # => ["11", "12", "120", "123", "2"]
Product.find(1021) y Product.find(10) # => codigo ~ 2
Product.find(604) y Product.find(437) # => codigo ~ 123
Product.find(227) y Product.find(8) # => codigo ~ 11
Product.find(867) y Product.find(106) # => codigo ~ 12
Product.find(406) y Product.find(603) # => codigo ~ 120
