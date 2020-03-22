# frozen_string_literal: true

require 'middleware'
require 'query_builder'

# Pipefy module.
module Pipefy
  API = 'pipefy'

  # Card is a ruby representation of Pipefy Card.
  class Card
    attr_accessor :id, :title

    @middleware = Middleware.instance
    @query_builder = QueryBuilder.new

    def initialize(id = nil, title = nil)
      @title = title
      @id = id
    end

    def self.find(id)
      query = @query_builder.build(API, 'card', 'find', { id: id })

      response = @middleware.do_request(API, query, 'POST')
      body = response.body

      Card.parse(body, 'find')
    end

    def self.all(pipe_id = nil)
      query = @query_builder.build(API, 'card', 'all', { pipe_id: pipe_id })
      response = @middleware.do_request(API, query, 'POST')
      body = response.body

      Pipefy::Card.parse(body, 'all')
    end

    def self.parse(response, method)
      response = JSON.parse(response)
      method = "parse_#{method}"
      Card.send(method, response)
    end

    def self.parse_find(response)
      id = response['data']['card']['id']
      title = response['data']['card']['title']

      Card.new(id, title)
    end

    def self.parse_all(response)
      nodes = response['data']['cards']['edges']
      cards = []

      nodes.each do |node|
        id = node['id']
        title = node['title']
        card = Card.new(id, title)
        cards << card
      end
      cards
    end
  end
end
