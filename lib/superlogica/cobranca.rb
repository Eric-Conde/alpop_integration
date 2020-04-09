# frozen_string_literal: true

require 'base'
require 'middleware/superlogica/superlogica_middleware'
require 'parser/superlogica_cobranca_parser'

# Superlogica module.
module Superlogica
  # Cobranca is a ruby representation of Superlogica Cobranca.
  class Cobranca < Base
    API = 'superlogica'

    attr_accessor :id, :vencimento

    @@middleware = SuperlogicaMiddleware.instance

    def initialize(id = nil)
      @id = id
    end

    def self.find(id)
      response_body = super('GET', { id: id })
    end

    def self.all
      response_body = super('GET')
    end

    def self.pendentes(params = nil, format = nil)
      query = query_builder.build(API, 'cobranca', 'pendentes', params)
      response = middleware.do_request(API, query, 'GET')

      body = response.body

      return body if format == 'json'

      Parser.parse(API, 'Cobranca', body, 'pendentes')
    end
  end
end
