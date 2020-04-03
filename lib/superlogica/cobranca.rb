# frozen_string_literal: true

require 'base'
require 'middleware'
require 'query_builder'
require 'parser/superlogica_cobranca_parser'

# Superlogica module.
module Superlogica
  # Cobranca is a ruby representation of Superlogica Cobranca.
  class Cobranca < Base
    API = 'superlogica'

    attr_accessor :id, :vencimento

    @middleware = Middleware.instance
    @query_builder = QueryBuilder.new

    def initialize(id = nil)
      @id = id
    end

    def self.find(id)
      body = super('find', 'GET', { id: id })
      Parser.parse(API, 'Cobranca', body, 'find')
    end

    def self.all
      query = @query_builder.build(API, 'cobranca', 'all')
      response = @middleware.do_request(API, query, 'GET')
      body = response.body

      Parser.parse(API, 'Cobranca', body, 'all')
    end

    def self.atrasadas
      query = @query_builder.build(API, 'cobranca', 'atrasadas')
      response = @middleware.do_request(API, query, 'GET')
      body = response.body

      Parser.parse(API, 'Cobranca', body, 'atrasadas')
    end
  end
end
