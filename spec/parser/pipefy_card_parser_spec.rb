# frozen_string_literal: true

require 'parser/pipefy_card_parser'

describe PipefyCardParser do
  context '.parse_find(response)' do
    context 'when calls parse_find(response)' do
      it 'returns a card with id and title' do
        card_json_response = '{"data": {"card": {"id": "60962201","pipe": ' \
                           '{"id": "1182718"},"title": "Rosangela "}}}'

        card = Parser.parse('pipefy', 'Card', card_json_response, 'find')

        expect(card.id).not_to be_nil
        expect(card.title).not_to be_nil
      end
    end
  end

  context '.parse_create(response)' do
    context 'when calls parse_create(response)' do
      it 'returns a card with id and title' do
        card_json_response = '{"data": {"createCard": {"card": {"id": "60962201","pipe": ' \
                           '{"id": "1182718"},"title": "Rosangela "}}}}'

        card = Parser.parse('pipefy', 'Card', card_json_response, 'create')

        expect(card.id).not_to be_nil
        expect(card.title).not_to be_nil
      end
    end
  end

  context '.parse_all(response)' do
    context 'when calls parse_all(response)' do
      it 'returns a card with id and title' do
        card_json_response = '{"data": {"cards": {"edges": [{"node": ' \
                                 '{"id": "59542804","title": ' \
                                 '"Andreza Sales Ferreira"}}]}}}'

        cards = Parser.parse('pipefy', 'Card', card_json_response, 'all')
        card = cards.first

        expect(cards.class).to eq Array
        expect(card.class).to eq Pipefy::Card
      end
    end
  end
end
