# frozen_string_literal: true

require 'parser/superlogica_contrato_parser'

describe SuperlogicaContratoParser do
  context '.parse_find(response)' do
    context 'when calls parse_find(response)' do
      it 'returns a contrato with id' do
        contrato_json_response = '{"status": "200", 
          "session": "vim1j791q3hgdqfstk7fe0ckp1",
          "msg": "",
          "data": [{
            "inquilinos": [{
              "id_sacado_sac": "7",
              "st_fantasia_pes": "Nat\u00e1lia Santiago dos Santos"
            }],
            "id_contrato_con": "1222",
            "id_tipo_con": "1",
            "dt_inicio_con": "06\/28\/2018",
            "dt_fim_con": "12\/27\/2020",
            "tx_adm_con": "10.00",
            "vl_aluguel_con": "1011.99",
            "nm_diavencimento_con": "28",
            "id_indicereajuste_con": "1",
            "proprietarios_beneficiarios": [{
              "st_fantasia_pes": "Eduardo Piva Laver",
              "st_nome_pes": "Eduardo Piva Laver"
            }],
            "nome_proprietario": "Eduardo Piva Laver",
            "fl_exibircobrancas": "1"
          }],
          "executiontime": "1.2973s"
        }'

        contrato = Parser.parse('superlogica', 'Contrato', 
                                contrato_json_response, 'find')

        expect(contrato.id).not_to be_nil
        expect(contrato.id).to eq 1222
      end
    end
  end
end
