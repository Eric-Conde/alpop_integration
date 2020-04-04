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

  def self.parse_inadimplentes(response)
    locatarios_inadimplentes = []
    data = response['data']

    data.each do |sacado|
      id_sacado_sac = sacado['id_sacado_sac']
      id = id_sacado_sac
      compo_recebimento = sacado['compo_recebimento']
      compo_recebimento_size = compo_recebimento.size

      if compo_recebimento_size >= 3
        locatario_inadimplente = Superlogica::Locatario
                                  .new(id, id_sacado_sac)
        locatario_inadimplente.cobrancas_atrasadas = compo_recebimento_size
        
        locatarios_inadimplentes << locatario_inadimplente 
      end
    end
    locatarios_inadimplentes
  end
end
