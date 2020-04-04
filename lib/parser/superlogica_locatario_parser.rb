# frozen_string_literal: true

require 'parser'
require 'superlogica/locatario'
require 'superlogica_locatario_parser_helper'

# Parser to process Superlogica Locatario responses.
class SuperlogicaLocatarioParser < Parser
  def self.parse_find(response)
    data = response['data'][0]
    id_pessoa_pes = data['id_pessoa_pes'].to_i

    Superlogica::Locatario.new(id_pessoa_pes)
  end

  def self.parse_ativos(response)
    data = response['data']
    locatarios_ativos = []

    detect_ativos(data)
  end

  def self.parse_inadimplentes(response)
    data = response['data']

    detect_inadimplentes(data)
  end

  class << self
    def detect_ativos(data)
      locatarios_ativos = []

      data.each do |locatario_ativo|
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

    def detect_inadimplentes(data)
      locatarios_inadimplentes = []

      data.each do |sacado|
        id, id_sacado_sac = sacado['id_sacado_sac']
        compo_recebimento = sacado['compo_recebimento']

        next if compo_recebimento.size < 3

        locatario_inadimplente = Superlogica::Locatario.new(id, id_sacado_sac)

        locatario_inadimplente.cobrancas_atrasadas = compo_recebimento.size
        locatarios_inadimplentes << locatario_inadimplente
      end
      locatarios_inadimplentes
    end
  end
end
