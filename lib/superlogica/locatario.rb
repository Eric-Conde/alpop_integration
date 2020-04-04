# frozen_string_literal: true

require 'base'
require 'middleware'
require 'query_builder'
require 'parser/superlogica_locatario_parser'

# Superlogica module.
module Superlogica
  # Locatario is a ruby representation of Superlogica Locatario.
  class Locatario < Base
    API = 'superlogica'

    attr_accessor :id, :id_sacado_sac, :nome, :active

    @middleware = Middleware.instance
    @query_builder = QueryBuilder.new

    def initialize(id = nil)
      @id = id
    end

    def self.find(id)
      body = super('find', 'GET', { id: id })
      Parser.parse(API, 'Locatario', body, 'find')
    end

    def self.ativos
      query = @query_builder.build(API, 'locatario', 'ativos')
      response = @middleware.do_request(API, query, 'GET')
      body = response.body

      Parser.parse(API, 'Locatario', body, 'ativos')
    end
  end
end
