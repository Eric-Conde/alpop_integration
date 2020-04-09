# frozen_string_literal: true

require 'parser/superlogica_locatario_parser'

describe SuperlogicaLocatarioParser do
  context '.parse_find(response)' do
    context 'when calls parse_find(response)' do
      it 'returns a locatario with id' do
        locatario_json_response = File.read("spec/fixtures/api/superlogica/" \
                                            "locatario_find.json")

        jsn_object = JSON.parse(locatario_json_response)
        expected_id = jsn_object['data'][0]['id_pessoa_pes']

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

  context '.parse_inadimplentes(response)' do
    context 'when calls parse_inadimplentes(response)' do
      it 'returns locatarios inadimplentes' do
        expected_locatarios_inadimplentes = []
        cobrancas_pendentes = []
        cobranca_pendente = {}

        cobrancas_pendentes_json_response = File.read("spec/fixtures/api/" \
                                          "superlogica/cobranca_pendentes.json")

        json_object = JSON.parse(cobrancas_pendentes_json_response)
        sacados = json_object['data'].first

        sacados_by_id = sacados.group_by { |sacado| sacado["id_sacado_sac"] }
        
        inadimplentes = sacados_by_id.filter_map do |sacado| 
          [sacado[1].first, sacado[1].size] if sacado[1].size >= 2
        end

        inadimplentes.each do |inadimplente|
          inadimplente_data = inadimplente.first
          cobrancas_pendentes = inadimplente.last

          id_sacado_sac = inadimplente_data['id_sacado_sac']
          id = id_sacado_sac

          locatario_inadimplente = Superlogica::Locatario.new(id)
          locatario_inadimplente.cobrancas_pendentes = cobrancas_pendentes
          expected_locatarios_inadimplentes << locatario_inadimplente
        end
        
        expect(expected_locatarios_inadimplentes.size).to eq 1
      end
    end
  end
end
