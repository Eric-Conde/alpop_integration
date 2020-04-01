# frozen_string_literal: true

require 'pipefy/card'

describe Pipefy::Card do
  describe 'initializer' do
    context 'when Pipefy::Card is initialized' do
      it 'sets card title' do
        card = build :card

        expect(card.title).not_to be_nil
      end

      it 'sets the card id' do
        card = build :card
        expect(card.id).not_to be_nil
      end
    end
  end

  describe '.find(id)' do
    before(:each) do
      find_card_by_id_response = '{"data":{"card":{"id":2122}}}'

      # Stub find card by id to avoid HTTP requests.
      stub_request(:post, /api.pipefy.com/)
        .with(headers: { 'Accept' => '*/*', 'User-Agent' => 'Ruby' })
        .to_return(status: 200, body: find_card_by_id_response, headers: {})
    end

    context 'when call .find(id)' do
      it 'retrieves a Card by id' do
        card = Pipefy::Card.find(2122)

        expect(card.id).to eq 2122
      end
    end
  end

  describe '.all' do
    before(:each) do
      all_cards_by_pipe_id = '{"data": {"cards": {"edges": [{"node": ' \
                                 '{"id": "59542804","title": ' \
                                 '"Andreza Sales Ferreira"}}]}}}'

      # Stub find card by id to avoid HTTP requests.
      stub_request(:post, /api.pipefy.com/)
        .with(headers: { 'Accept' => '*/*', 'User-Agent' => 'Ruby' })
        .to_return(status: 200, body: all_cards_by_pipe_id, headers: {})
    end

    context 'when call .all(pipe_id)' do
      it 'returns an array of Card objects' do
        pipe_id = '1182718'
        cards = Pipefy::Card.all(pipe_id)
        card = cards.first

        expect(cards.class).to eq Array
        expect(card.class).to eq Pipefy::Card
      end
    end
  end

  describe 'when call .create(pipe_id)' do
    before(:each) do
      created_card = '{"data":{"createCard":{"card":{"id":"61492643", '\
                      '"title":"Card teste Atendimento"}}}}'

      # Stub find card by id to avoid HTTP requests.
      stub_request(:post, /api.pipefy.com/)
        .with(headers: { 'Accept' => '*/*', 'User-Agent' => 'Ruby' })
        .to_return(status: 200, body: created_card, headers: {})
    end

    it 'returns card object' do
      params = { pipe_id: '1182718', due_date: '2020-03-15',
                 assignee_ids: ['975211'], phase_id: '7910051',
                 title: 'Card teste Atendimento', fields_attributes: [] }

      card = Pipefy::Card.create(params)
      expect(card).not_to be_nil
    end
  end

  describe 'when call .parse' do
    it 'returns Card object' do
      card_json_response = '{"data": {"card": {"id": "60962201","pipe": ' \
                           '{"id": "1182718"},"title": "Rosangela "}}}'

      card = Pipefy::Card.parse(card_json_response, 'find')

      expect(card.id).not_to be_nil
      expect(card.title).not_to be_nil
    end
  end
end
