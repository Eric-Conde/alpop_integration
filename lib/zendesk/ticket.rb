# frozen_string_literal: true

module Zendesk
  # Zendesk Ticket ruby object.
  class Ticket
    attr_accessor :id

    def initialize(id = nil)
      @id = id
    end

    def self.parse(response)
      json_response = JSON.parse(response)
      ticket_id = json_response['ticket']['id']
      Ticket.new(ticket_id)
    end
  end
end
