# frozen_string_literal: true

require 'pipefy/card'

describe Pipefy::Card do
  describe 'initializer' do
    context 'when Pipefy::Card is initialized' do
      it 'sets the card title' do
        card = build :card

        expect(card.title).not_to be_nil
      end

      it 'sets the card id' do
        card = build :card
        expect(card.id).not_to be_nil
      end
    end
  end

  describe '.find' do
    before(:each) do
      find_card_by_id_response = '{"data":{"card":{"id":2122}}}'

      # Stub find card by id to avoid HTTP requests.
      stub_request(:post, /api.pipefy.com/)
        .with(headers: { 'Accept' => '*/*', 'User-Agent' => 'Ruby' })
        .to_return(status: 200, body: find_card_by_id_response, headers: {})
    end

    context 'when .find() is called' do
      it 'retrieves a Card by id' do
        ticket = Pipefy::Card.find(2122)

        expect(ticket.id).to eq 2122
      end
    end
  end

  describe '.all' do
    before(:each) do
      all_cards_by_pipe_id = '{"data": {"cards": {"edges": [{"node": ' + 
                                 '{"id": "59542804","title": '+ 
                                 '"Andreza Sales Ferreira"}}]}}}'

      # Stub find card by id to avoid HTTP requests.
      stub_request(:post, /api.pipefy.com/)
        .with(headers: { 'Accept' => '*/*', 'User-Agent' => 'Ruby' })
        .to_return(status: 200, body: all_cards_by_pipe_id, headers: {})
    end

    context 'when .all(pipe_id) is called' do
      it 'returns an array of Card objects' do
        response = '{"data": {"cards": {"edges": [{"node": ' + 
                   '{"id": "59542804","title": "Andreza Sales Ferreira"}}]}}}'

        pipe_id = '1182718'
        api = 'pipefy'
        query = "{\"query\":\"{ cards(pipe_id: #{pipe_id}, first: 10)" +
               "{ edges { node {id title} } } }\"}"

 
        cards = Pipefy::Card.all(pipe_id)
        card = cards.first

        expect(cards.class).to eq Array
        expect(card.class).to eq Pipefy::Card
      end
    end
  end

  describe '.parse' do
    context 'when .parse(find) is called' do
      it 'returns Card object' do
        card_json_response = '{"data": {"card": {"id": "60962201","pipe": ' + 
                             '{"id": "1182718"},"title": "Rosangela "}}}'

        card = Pipefy::Card.parse(card_json_response, 'find')

        expect(card.id).not_to be_nil
        expect(card.title).not_to be_nil
      end
    end
  end
end
