# frozen_string_literal: true

require 'base'
require 'middleware'
require 'query_builder'
require 'parser/pipefy_card_parser'

# Pipefy module.
module Pipefy
  # Card is a ruby representation of Pipefy Card.
  class Card < Base
    API = 'pipefy'

    attr_accessor :id, :title

    @middleware = Middleware.instance
    @query_builder = QueryBuilder.new

    def initialize(id = nil, title = nil)
      @title = title
      @id = id
    end

    def self.find(id)
      response_body = super('find', 'POST', { id: id })
      Parser.parse(API, 'Card', response_body, 'find')
    end

    def self.all(pipe_id = nil)
      query = @query_builder.build(API, 'card', 'all', { pipe_id: pipe_id })
      response = @middleware.do_request(API, query, 'POST')
      body = response.body

      Parser.parse(API, 'Card', body, 'all')
    end

    def self.create(params)
      query = @query_builder.build(API, 'card', 'create', params)
      response = @middleware.do_request(API, query, 'POST')
      body = response.body

      Parser.parse(API, 'Card', body, 'create')
    end
  end
end
