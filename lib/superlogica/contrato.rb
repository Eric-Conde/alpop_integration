# frozen_string_literal: true

require 'base'
require 'middleware'
require 'query_builder'

# Superlogica module.
module Superlogica
  # Contrato is a ruby representation of Superlogica Contrato.
  class Contrato < Base

    attr_accessor :id

    @middleware = Middleware.instance
    @query_builder = QueryBuilder.new

    def initialize(id = nil)
      @id = id
    end

    def self.find(id)
      response_body = super('find', 'GET', { id: id })
      Contrato.parse(response_body, 'find')
    end

    def self.parse(response, contrato_method)
      response = JSON.parse(response)
      contrato_method = "parse_#{contrato_method}"
      Contrato.send(contrato_method, response)
    end

    def self.parse_find(response)
      id = response['data'][0]['id_contrato_con'].to_i

      Contrato.new(id)
    end
  end
end
