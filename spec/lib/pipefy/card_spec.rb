# frozen_string_literal: true

require 'pipefy/card'
require 'parser'

describe Pipefy::Card do
  describe 'initializer' do
    context 'when Pipefy::Card is initialized' do
      # it 'sets card title' do
      #   card = build :card

      #   expect(card.title).not_to be_nil
      # end

      it 'sets the card id' do
        card = build :card
        expect(card.id).not_to be_nil
      end
    end
  end

  describe '.find(id)' do
    before(:each) do
      find_card_by_id_response = File.read("spec/fixtures/api/pipefy/" \
                                           "card_find.json")

      # Stub find card by id to avoid HTTP requests.
      stub_request(:post, "https://api.pipefy.com/graphq").
         with(
          headers: {
          'Connection'=>'close',
          'Host'=>'api.pipefy.com',
          'User-Agent'=>'http.rb/4.4.1'
           }).
         to_return(status: 200, body: find_card_by_id_response, headers: {})
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
      all_cards_by_pipe_id = File.read("spec/fixtures/api/pipefy/" \
                                       "card_all.json")

      # Stub find card by id to avoid HTTP requests.
      stub_request(:post, "https://api.pipefy.com/graphq").
         with(
           headers: {
          'Connection'=>'close',
          'Host'=>'api.pipefy.com',
          'User-Agent'=>'http.rb/4.4.1'
           }).
         to_return(status: 200, body: all_cards_by_pipe_id, headers: {})
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
      created_card = File.read("spec/fixtures/api/pipefy/card_create.json")

      # Stub find card by id to avoid HTTP requests.
       stub_request(:post, "https://api.pipefy.com/graphq").
         with(
           headers: {
          'Connection'=>'close',
          'Host'=>'api.pipefy.com',
          'User-Agent'=>'http.rb/4.4.1'
           }).
         to_return(status: 200, body: created_card, headers: {})
    end

    it 'returns card object' do
      params = { pipe_id: '1182718', due_date: '2020-03-15',
                 assignee_ids: ['975211'], phase_id: '7910051',
                 title: 'Card teste Atendimento', fields_attributes: [] }

      card = Pipefy::Card.create(params)
      expect(card).not_to be_nil
    end
  end
end
