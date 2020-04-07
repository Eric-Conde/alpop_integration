# frozen_string_literal: true

require 'parser'
require 'superlogica/locatario'
require 'superlogica_locatario_parser_helper'

# Parser to process Superlogica Locatario responses.
class SuperlogicaLocatarioParser < Parser
  def self.parse_find(response)
    data = response['data'].first
    id_pessoa_pes = data['id_pessoa_pes']

    Superlogica::Locatario.new(id_pessoa_pes)
  end

  def self.parse_ativos(response)
    data = response['data']
    detect_ativos(data)
  end

  def self.parse_inadimplentes(response)
    data = response['data'].first

    detect_inadimplentes(data) if data != ""
  end

  class << self
    def detect_ativos(data)
      locatarios_ativos = []

      data.each do |locatario_ativo|
        id_pessoa_pes = locatario_ativo['id_pessoa_pes']
        id_sacado_sac = locatario_ativo['id_sacado_sac']
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
      cobrancas_atrasadas = []
      locatarios_inadimplentes = []
      sacados = data

      sacados_by_id = sacados.group_by { |sacado| sacado['id_sacado_sac'] }

      inadimplentes = sacados_by_id.filter_map do |sacado|
        [sacado[1].first, sacado[1].size] if sacado[1].size >= 2
      end

      inadimplentes.each do |inadimplente|
        inadimplente_data = inadimplente.first
        cobrancas_atrasadas = inadimplente.last
        id = inadimplente_data['id_sacado_sac']
        nome = inadimplente_data['st_nomeref_sac']

        locatario_inadimplente = build_locatario(id, cobrancas_atrasadas, nome)
        locatarios_inadimplentes << locatario_inadimplente
      end
      locatarios_inadimplentes
    end

    def build_locatario(id, cobrancas_atrasadas, nome)
      locatario_inadimplente = Superlogica::Locatario.new(id)
      locatario_inadimplente.cobrancas_atrasadas = cobrancas_atrasadas
      locatario_inadimplente.nome = nome

      locatario_inadimplente
    end
  end
end
