# frozen_string_literal: true

require 'query_builder'

describe QueryBuilder do
  describe '.build' do
    context 'when .build is called' do
      it 'returns query' do
        api = 'pipefy'
        object = 'card'
        api_method = 'find'
        params = { id: 1202 }
        expected_query = "{\"query\":\"{ card(id: \\\"#{params[:id]}\\\")" \
                         ' {title, pipe {id}}}"}'

        query_builder = QueryBuilder.new
        query = query_builder.build(api, object, api_method, params)
        expect(query).to eq expected_query
      end
    end
  end
end
