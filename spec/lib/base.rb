# frozen_string_literal: true

require 'base'
require 'pipefy/card'

describe Base
  context 'when .find is called' do
    it 'retrieves a object by id' do
      card = Pipefy::Card.find(2122)

      expect(card.id).to eq 2122
    end
  end
end
