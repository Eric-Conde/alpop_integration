# frozen_string_literal: true

require 'middleware'

# Pipefy module.
module Pipefy
  # Card is a ruby representation of Pipefy Card.
  class Card
    attr_accessor :id, :title

    @middleware = Middleware.instance

    def initialize(id = nil, title = nil)
      @title = title
      @id = id
    end

    def self.find(id)
      api = 'pipefy'
      query = "{\"query\":\"{ card(id: \\\"#{id}\\\")" \
              ' {title, pipe {id}}}"}'

      response = @middleware.do_request(api, query, 'POST')
      body = response.body

      Pipefy::Card.parse(body, 'find')
    end

    def self.all(pipe_id = nil)
      api = 'pipefy'

      query = "{\"query\":\"{ cards(pipe_id: #{pipe_id}, first: 10)" \
              "{ edges { node {id title} } } }\"}"

      response = @middleware.do_request(api, query, 'POST')
      body = response.body

      Pipefy::Card.parse(body, 'all')
    end

    def self.parse(response, card_method)
      response = JSON.parse(response)
      
      card_method = "parse_#{card_method}"

      Pipefy::Card.send(card_method, response)
    end

    def self.parse_find(response)
      id = response['data']['card']['id']
      title = response['data']['card']['title']
      
      Pipefy::Card.new(id, title)
    end

    def self.parse_all(response)
      nodes = response['data']['cards']['edges']
      cards = []
      
      nodes.each do |node|
        id = node['id']
        title = node['title']
        
        card = Pipefy::Card.new(id, title)
        cards << card
      end
      cards
    end
  end
end
