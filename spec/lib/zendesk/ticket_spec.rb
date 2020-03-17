# frozen_string_literal: true

require 'zendesk/ticket'

describe Zendesk::Ticket do
  describe 'initializer' do
    context 'when Zendesk::Ticket is initialized' do
      it 'must sets the ticket id' do
        ticket = build :ticket

        expect(ticket.id).not_to be_nil
      end
    end
  end
end
