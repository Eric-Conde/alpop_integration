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

        cobranca = Parser.parse('superlogica', 'Cobranca', cobranca_json_response,
                                'find')

        expect(cobranca.id).not_to be_nil
        expect(cobranca.id).to eq 651
      end
    end
  end
end
