# frozen_string_literal: true

require 'parser/superlogica_locatario_parser'

describe SuperlogicaLocatarioParser do
  context '.parse_find(response)' do
    context 'when calls parse_find(response)' do
      it 'returns a locatario with id' do
        locatario_json_response = File.read("spec/fixtures/api/superlogica/" \
                                            "locatario_find.json")

        jsn_object = JSON.parse(locatario_json_response)
        expected_id = jsn_object['data'][0]['id_pessoa_pes'].to_i

        locatario = Parser.parse('superlogica', 'Locatario', 
                                locatario_json_response, 'find')

        expect(locatario.id).not_to be_nil
        expect(locatario.id).to eq expected_id
      end
    end
  end
end
