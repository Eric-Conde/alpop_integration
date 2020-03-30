# frozen_string_literal: true

require 'middleware'
require 'query_builder'
require 'base'

# Pipefy module.
module Pipefy
  # Phase is a ruby representation of Pipefy Phase.
  class Phase < Base
    API = 'pipefy'

    attr_accessor :id

    @middleware = Middleware.instance
    @query_builder = QueryBuilder.new

    def initialize(id = nil)
      @id = id
    end

    def self.find(id)
      response_body = super('find', 'POST', { id: id })
      Phase.parse(response_body, 'find')
    end

    def self.parse(response, card_method)
      response = JSON.parse(response)
      card_method = "parse_#{card_method}"
      Phase.send(card_method, response)
    end

    def self.parse_find(response)
      id = response['data']['phase']['id']

      Phase.new(id)
    end
  end
end
