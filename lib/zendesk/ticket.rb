# frozen_string_literal: true

require 'middleware'

# Zendesk module.
module Zendesk
  # Zendesk Ticket ruby object.
  class Ticket
    attr_accessor :id

    @middleware = Middleware.instance

    def initialize(id = nil)
      @id = id
    end

    def self.find(id)
      api = 'zendesk'
      query = "tickets/#{id}"
      response = @middleware.do_request(api, query, 'GET')
      body = response.body
      Zendesk::Ticket.parse(body)
    end

    def self.parse(response)
      json_response = JSON.parse(response)
      ticket_id = json_response['ticket']['id']
      Ticket.new(ticket_id)
    end
  end
end
