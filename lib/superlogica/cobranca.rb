# frozen_string_literal: true

require 'middleware'
require 'query_builder'

# Superlogica module.
module Superlogica
  API = 'superlogica'

  # Cobranca is a ruby representation of Superlogica Cobranca.
  class Cobranca
    attr_accessor :id, :st_nome_sac

    @middleware = Middleware.instance
    @query_builder = QueryBuilder.new

    def initialize(id = nil, st_nome_sac = nil)
      @st_nome_sac = st_nome_sac
      @id = id
    end

    def self.find(id)
      query = @query_builder.build(API, 'cobranca', 'find', { id: id })

      response = @middleware.do_request(API, query, 'GET')
      body = response.body

      Cobranca.parse(body, 'find')
    end

    def self.parse(response, cobranca_method)
      response = JSON.parse(response)
      cobranca_method = "parse_#{cobranca_method}"
      Cobranca.send(cobranca_method, response)
    end

    def self.parse_find(response)
      id = response[0]['compo_recebimento'][0]['id_boleto_comp']
      st_nome_sac = response[0]['st_nome_sac']
      Cobranca.new(id, st_nome_sac)
    end
  end
end
