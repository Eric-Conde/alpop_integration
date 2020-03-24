# frozen_string_literal: true

require 'middleware'
require 'query_builder'

# Pipefy module.
module Pipefy
  API = 'pipefy'

  # Phase is a ruby representation of Pipefy Phase.
  class Phase
    attr_accessor :id

    @middleware = Middleware.instance
    @query_builder = QueryBuilder.new

    def initialize(id = nil)
      @id = id
    end

    def self.find(id)
      query = @query_builder.build(API, 'phase', 'find', { id: id })

      response = @middleware.do_request(API, query, 'POST')
      body = response.body

      Phase.parse(body, 'find')
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
