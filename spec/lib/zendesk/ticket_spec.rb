# frozen_string_literal: true

require 'zendesk/ticket'

describe Zendesk::Ticket do
  before(:each) do
    find_ticket_by_id = '{"ticket": {"url": "2122.json", "id": 2122}}'

    # Stub find card by id to avoid HTTP requests.
    stub_request(:get, 'https://alpophelp.zendesk.com/api/v2/tickets/2122')
      .with(headers: { 'Accept' => '*/*', 'User-Agent' => 'Ruby' })
      .to_return(status: 200, body: find_ticket_by_id, headers: {})
  end

  describe 'initializer' do
    context 'when Zendesk::Ticket is initialized' do
      it 'sets the ticket id' do
        ticket = build :ticket

        expect(ticket.id).not_to be_nil
      end
    end
  end

  describe '.find' do
    context 'when .find() is called' do
      it 'retrieves a Ticket by id' do
        ticket = Zendesk::Ticket.find(2122)

        expect(ticket.id).to eq 2122
      end
    end
  end
end
