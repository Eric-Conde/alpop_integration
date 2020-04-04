require 'parser'
require 'superlogica/locatario'

class SuperlogicaLocatarioParser < Parser
  def self.parse_find(response)
    data = response['data'][0]
    id_pessoa_pes = data['id_pessoa_pes'].to_i

    Superlogica::Locatario.new(id_pessoa_pes)
  end

  def self.parse_ativos(response)
    locatarios_ativos_json = response['data']
    locatarios_ativos = []

    locatarios_ativos_json.each do |locatario_ativo|
      id_pessoa_pes = locatario_ativo['id_pessoa_pes'].to_i
      id_sacado_sac = locatario_ativo['id_sacado_sac'].to_i
      st_nome_pes = locatario_ativo['st_nome_pes']
      
      locatario = Superlogica::Locatario.new(id_pessoa_pes)
      locatario.id_sacado_sac = id_sacado_sac
      locatario.nome = st_nome_pes
      locatario.active = true

      locatarios_ativos << locatario
    end
    locatarios_ativos
  end
end
