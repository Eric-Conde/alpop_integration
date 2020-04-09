# frozen_string_literal: true

require 'parser'
require 'zendesk/ticket'

# Parser to process Zendesk ticket responses.
class ZendeskTicketParser < Parser
  def self.parse_find(response)
    id = response['ticket']['id']
    Zendesk::Ticket.new(id)
  end
end
