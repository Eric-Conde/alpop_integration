# frozen_string_literal: true

require 'parser/superlogica_cobranca_parser'

describe SuperlogicaCobrancaParser do
  context '.parse_find(response)' do
    context 'when calls parse_find(response)' do
      it 'returns a cobranca with id' do
        cobranca_json_response = '[{ "id_sacado_sac": "16028",
          "st_nomeref_sac": "Integracao",
          "st_nome_sac": "Integracao", "compo_recebimento": [{
          "st_descricao_prd": "Adesão", "st_mesano_comp": "07/01/2019",
          "st_descricao_comp": "","st_valor_comp": "500.00",
          "id_boleto_comp": "651","id_sacado_comp": "16028" }] }]'

        cobranca = Parser.parse('superlogica', 'Cobranca', 
                                cobranca_json_response, 'find')

        expect(cobranca.id).not_to be_nil
        expect(cobranca.id).to eq 651
      end
    end
  end

  context '.parse_all(response)' do
    let(:cobranca_json_response) do
      '{
        "status": "200",
        "session": "vim1j791q3hgdqfstk7fe0ckp1",
        "msg": "",
        "data": [
          [{
            "id_sacado_sac": "161",
            "st_nomeref_sac": "F\u00e1bio Alessandro Bonfim Vilas Boas",
            "st_nome_sac": "F\u00e1bio Alessandro Bonfim Vilas Boas",
            "compo_recebimento": [{"id_boleto_comp":"1091"}]
          }, {
            "id_sacado_sac": "201",
            "st_nomeref_sac": "Lucas Aparecido Ribeiro",
            "st_nome_sac": "Lucas Aparecido Ribeiro",
            "compo_recebimento": [{"id_boleto_comp":"1091"}]
          }]
        ],
          "executiontime": "0.1561s"
      }'
    end

    context 'when calls parse_all(response)' do
      it 'returns an array of Cobranca' do
        cobrancas = Parser.parse('superlogica', 'Cobranca', 
                                cobranca_json_response, 'all')

        cobranca = cobrancas.first

        expect(cobrancas.class).to eq Array
        expect(cobranca.class).to eq Superlogica::Cobranca
      end
    end
  end
end
