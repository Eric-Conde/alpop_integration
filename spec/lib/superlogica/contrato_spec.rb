# frozen_string_literal: true

require 'superlogica/contrato'

describe Superlogica::Contrato do
  let(:find_contrato_by_id_reponse) do 
    '{
      "status": "200",
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
  end

  describe 'initializer' do
    context 'when Superlogica::Contrato is initialized' do
      it 'sets the contrato id' do
        contrato = build :contrato
        expect(contrato.id).not_to be_nil
      end
    end
  end

  describe '.find(id)' do
    context 'when call .find(id)' do
      before(:each) do
        stub_request(:get, "https://apps.superlogica.net:80/imobiliaria/" \
                           "api/contratos?comDadosDosInquilinos=1&" \
                           "comDadosDosProprietarios=1&id=1222")
          .with(
            headers: {
                'Accept'=>'*/*',
                'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                'Access-Token'=>'put_here_your_credentials',
                'Authorization'=>'put_here_your_credentials',
                'Host'=>'apps.superlogica.net',
                'User-Agent'=>'Ruby'
            }).to_return(status: 200, body: find_contrato_by_id_reponse, 
                         headers: {})
      end

      it 'retrieves contrato by id' do
        contrato = Superlogica::Contrato.find(1222)

        expect(contrato.id).to eq 1222
      end
    end
  end

  describe 'when call .parse' do
    it 'returns Contrato object' do
      contrato_json_response = find_contrato_by_id_reponse
      contrato = Superlogica::Contrato.parse(contrato_json_response, 'find')

      expect(contrato.id).not_to be_nil
    end
  end
end
