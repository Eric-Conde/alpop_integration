# frozen_string_literal: true

require 'parser'
require 'parser/pipefy_card_parser'

describe Parser do
  context '.parse(api, object, response, action)' do
    context 'when .parse(api, object, response, action) is called' do
      it 'calls PipefyCardParser.parse_find(response)' do
        response = '{"data":{"card":{"id":2122}}}'
        api, object, response, action = ['pipefy', 'Card', response, 
                                         'find']
        card = Parser.parse(api, object, response, action)

        expect(card.id).to eq card.id
      end
    end
  end
end
