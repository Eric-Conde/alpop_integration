# frozen_string_literal: true

require 'parser/zendesk_user_parser'

describe ZendeskUserParser do
  context '.parse_find(response)' do
    context 'when calls parse_find(response)' do
      it 'returns a user with id' do
        user_json_response = '{"user": {"id": 2122}}'

        user = Parser.parse('zendesk', 'User', user_json_response, 'find')

        expect(user.id).not_to be_nil
        expect(user.id).to eq 2122
      end
    end
  end
end
