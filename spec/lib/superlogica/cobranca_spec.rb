# frozen_string_literal: true

require 'superlogica/cobranca'

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
      it 'sets cobranca name' do
        cobranca = build :cobranca

        expect(cobranca.st_nome_sac).not_to be_nil
      end

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

        expect(cobranca.id).to eq '651'
      end
    end
  end

  describe 'when call .parse' do
    it 'returns Cobranca object' do
      cobranca = Superlogica::Cobranca.parse(find_cobranca_by_id, 'find')

      expect(cobranca.id).not_to be_nil
      expect(cobranca.st_nome_sac).not_to be_nil
    end
  end
end
