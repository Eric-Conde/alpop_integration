# frozen_string_literal: true

require 'pipefy/card'

describe Pipefy::Card do
  describe 'initializer' do
    context 'when Pipefy::Card is initialized' do
      it 'must sets the card title' do
        card = build :card

        expect(card.title).not_to be_nil
      end

      it 'must sets the card pipe id' do
        card = build :card
        expect(card.pipe_id).not_to be_nil
      end
    end
  end
end
