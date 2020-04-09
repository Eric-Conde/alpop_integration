# frozen_string_literal: true

require 'base'

# Zendesk module.
module Zendesk
  # Zendesk Ticket ruby object.
  class Ticket < Base
    API = 'zendesk'

    attr_accessor :id

    @middleware = Middleware.instance
    @query_builder = QueryBuilder.new

    def initialize(id = nil)
      @id = id
    end

    def self.find(id)
      response_body = super('GET', { id: id })
    end

    def self.parse(response, method)
      response = JSON.parse(response)
      method = "parse_#{method}"
      Ticket.send(method, response)
    end

    def self.parse_find(response)
      ticket_id = response['ticket']['id']
      Ticket.new(ticket_id)
    end
  end
end
