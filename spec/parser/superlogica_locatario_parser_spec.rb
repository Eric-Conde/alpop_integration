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

  context '.parse_inadimplentes(response)' do
    context 'when calls parse_inadimplentes(response)' do
      it 'returns locatarios inadimplentes' do
        expected_locatarios_inadimplentes = []
        cobrancas_atrasadas_json_response = File.read("spec/fixtures/api/" \
                                          "superlogica/cobranca_atrasadas.json")

        json_object = JSON.parse(cobrancas_atrasadas_json_response)
        
        data = json_object['data']

        data.each do |sacado|
          id_sacado_sac = sacado['id_sacado_sac']
          id = id_sacado_sac
          compo_recebimento = sacado['compo_recebimento']
          compo_recebimento_size = compo_recebimento.size

          if compo_recebimento_size >= 3
            locatario_inadimplente = Superlogica::Locatario
                                      .new(id, id_sacado_sac)
            locatario_inadimplente.cobrancas_atrasadas = compo_recebimento_size
            expected_locatarios_inadimplentes << locatario_inadimplente 
          end
        end
        
        expect(expected_locatarios_inadimplentes.size).to eq 1
      end
    end
  end
end
