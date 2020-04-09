# frozen_string_literal: true

require 'base'
require 'superlogica/cobranca'
require 'parser/superlogica_locatario_parser'

# Superlogica module.
module Superlogica
  # Locatario is a ruby representation of Superlogica Locatario.
  class Locatario < Base
    API = 'superlogica'

    attr_accessor :id, :id_sacado_sac, :nome, :active, :cobrancas_pendentes

    def initialize(id = nil)
      @id = id
      @id_sacado_sac = id
    end

    def self.find(id)
      response_body = super('GET', { id: id })
    end

    def self.ativos
      query = query_builder.build(API, 'locatario', 'ativos')
      response = middleware.do_request(API, query, 'GET')
      body = response.body
      Parser.parse(API, 'Locatario', body, 'ativos')
    end

    def self.inadimplentes(dtInicio = nil, dtFim = nil)
      cobrancas_pendentes = Cobranca.pendentes({dtInicio: dtInicio, dtFim: dtFim}, 'json')
      Parser.parse(API, 'Locatario', cobrancas_pendentes, 'inadimplentes')
    end
  end
end
