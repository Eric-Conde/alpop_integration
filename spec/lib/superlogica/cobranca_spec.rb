# frozen_string_literal: true

require 'superlogica/cobranca'
require 'parser'

describe Superlogica::Cobranca do
  
  let(:find_cobranca_by_id) do
    '[{ "id_sacado_sac": "16028",
    "st_nomeref_sac": "Integracao",
    "st_nome_sac": "Integracao", "compo_recebimento": [{
    "st_descricao_prd": "Adesão", "st_mesano_comp": "07/01/2019",
    "st_descricao_comp": "","st_valor_comp": "500.00",
    "id_boleto_comp": "651","id_sacado_comp": "16028" }] }]'
  end

  describe 'initializer' do
    context 'when Superlogica::Cobranca is initialized' do
      it 'sets the cobranca id' do
        cobranca = build :cobranca
        expect(cobranca.id).not_to be_nil
      end
    end
  end

  describe '.find' do
    before(:each) do
      # Stub find cobranca by id to avoid HTTP requests.
      stub_request(:get, "https://apps.superlogica.net:80/" \
                         "imobiliaria/api/cobrancas?id=651")
          .with(headers: {
            'Accept'=>'*/*',
            'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Access-Token'=>'put_here_your_credentials',
            'Authorization'=>'put_here_your_credentials',
            'Host'=>'apps.superlogica.net',
            'User-Agent'=>'Ruby'
          }).
         to_return(status: 200, body: find_cobranca_by_id, headers: {})
    end

    context 'when call .find()' do
      it 'retrieves a Cobranca by id' do
        cobranca = Superlogica::Cobranca.find(651)

        expect(cobranca.id).to eq 651
      end
    end
  end

  describe '.all' do
    context 'when call .all' do
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

      before(:each) do
        stub_request(:get, 
            "https://apps.superlogica.net:80/imobiliaria/api/cobrancas")
          .with(
            headers: {
            'Accept'=>'*/*',
            'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Access-Token'=>'put_here_your_credentials',
            'Authorization'=>'put_here_your_credentials',
            'Host'=>'apps.superlogica.net',
            'User-Agent'=>'Ruby'
            }).to_return(status: 200, body: cobranca_json_response, headers: {})
      end

      it 'returns an array of Cobranca objects' do
        cobrancas = Superlogica::Cobranca.all
        cobranca = cobrancas.first

        expect(cobrancas.class).to eq Array
        expect(cobranca.class).to eq Superlogica::Cobranca
      end
    end
  end
end
