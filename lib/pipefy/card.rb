# frozen_string_literal: true

require 'base'
require 'middleware'
require 'query_builder'

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
      Card.parse(response_body, 'find')
    end

    def self.all(pipe_id = nil)
      query = @query_builder.build(API, 'card', 'all', { pipe_id: pipe_id })
      response = @middleware.do_request(API, query, 'POST')
      body = response.body

      Card.parse(body, 'all')
    end

    def self.create(params)
      query = @query_builder.build(API, 'card', 'create', params)
      response = @middleware.do_request(API, query, 'POST')
      body = response.body

      Card.parse(body, 'create')
    end

    def self.parse(response, card_method)
      response = JSON.parse(response)
      card_method = "parse_#{card_method}"
      Card.send(card_method, response)
    end

    def self.parse_find(response)
      id = response['data']['card']['id']
      title = response['data']['card']['title']

      Card.new(id, title)
    end

    def self.parse_create(response)
      card = response['data']['createCard']['card']
      id = card['id']
      title = card['title']

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
