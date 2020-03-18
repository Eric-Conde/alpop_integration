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

      Pipefy::Card.parse(body)
    end

    def self.parse(response)
      json_response = JSON.parse(response)
      id = json_response['data']['card']['id']
      title = json_response['data']['card']['title']

      Pipefy::Card.new(id, title)
    end
  end
end
