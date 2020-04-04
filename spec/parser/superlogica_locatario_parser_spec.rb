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

  context '.parse_ativos(response)' do
    context 'when calls parse_ativos(response)' do
      it 'returns all the active locatarios' do
        ativos_json_response = File.read("spec/fixtures/api/superlogica/" \
                                            "locatario_ativos.json")

        jsn_object = JSON.parse(ativos_json_response)
        active_locatarios = jsn_object['data']

        locatarios = Parser.parse('superlogica', 'Locatario', 
                                ativos_json_response, 'ativos')

        expect(locatarios.size).to eq active_locatarios.size
      end
    end
  end
end
