# frozen_string_literal: true

require 'parser/zendesk_ticket_parser'

describe ZendeskTicketParser do
  context '.parse_find(response)' do
    context 'when calls parse_find(response)' do
      it 'returns a ticket with id' do
        ticket_json_response = '{"ticket": {"id": 2122}}'

        ticket = Parser.parse('zendesk', 'Ticket', ticket_json_response, 'find')

        expect(ticket.id).not_to be_nil
        expect(ticket.id).to eq 2122
      end
    end
  end
end
