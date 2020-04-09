# frozen_string_literal: true

require 'base'
require 'parser/zendesk_ticket_parser'

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
  end
end
