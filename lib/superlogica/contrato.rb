# frozen_string_literal: true

require 'base'
require 'middleware'
require 'query_builder'
require 'parser/superlogica_contrato_parser'

# Superlogica module.
module Superlogica
  # Contrato is a ruby representation of Superlogica Contrato.
  class Contrato < Base
    API = 'superlogica'

    attr_accessor :id

    @middleware = Middleware.instance
    @query_builder = QueryBuilder.new

    def initialize(id = nil)
      @id = id
    end

    def self.find(id)
      body = super('find', 'GET', { id: id })
      Parser.parse(API, 'Contrato', body, 'find')
    end

    def self.all
      body = super('all', 'GET')
      Parser.parse(API, 'Contrato', body, 'all')
    end
  end
end
