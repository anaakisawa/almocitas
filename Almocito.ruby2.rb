require "csv" 

# definindo seed do random
# srand 10

# arquivos
csv = CSV.read("./nomes_almoco.csv", headers: true)
grupos_antigos_csv = CSV.read("./grupos_almoco.csv", headers: true)

grupos_antigos = grupos_antigos_csv.group_by { |row| row['grupo'] }.map { |nome_grupo, pessoas| pessoas }

def sortear(csv, grupos_antigos)
	csv = csv.each.to_a.shuffle
	areas = csv.map{ |linha| linha[2] }.uniq

	pessoas_por_area = areas.each_with_object({}) do |area, b|
	  b.merge!(area => csv.select{ |linha| linha[2] == area})
	end

	quantidade_de_grupos = (csv.length / 5.0).ceil

	grupos = 1.upto(quantidade_de_grupos).map { [] }

  proximo_grupo = grupos.cycle

  pessoas_por_area.each do |area, pessoas|
    pessoas.each do |pessoa|
      proximo_grupo.next << pessoa
    end
  end

  grupos.each do |grupo|
  	emails = grupo.map { |p| p['Email'] }

    grupo.each do |pessoa|
      grupos_antigos.each do |grupo_antigo|
        emails_grupo_antigo = grupo_antigo.map { |p| p['Email'] }

        # p emails_grupo_antigo & emails
        if (emails_grupo_antigo & emails).length > 1
          return nil
        end
      end
    end
  end

  grupos
end

grupos = nil

sorteios = 0

loop do
	sorteios += 1
  grupos = sortear(csv, grupos_antigos)

  break if grupos
end

grupos.each.with_index do | grupo, numero |
  puts "grupo #{numero + 1}:"
  grupo.each do | pessoa |
    puts " - #{pessoa}"
  end 
end




