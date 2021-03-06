# frozen_string_literal: true

require 'superlogica/contrato'
require 'parser'

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
        stub_request(:get, "https://apps.superlogica.net/imobiliaria/api/contratos?comDadosDosInquilinos=1&comDadosDosProprietarios=1&id=1222").
          with(
            headers: {
            'Connection'=>'close',
            'Host'=>'apps.superlogica.net',
            'User-Agent'=>'http.rb/4.4.1'
            }).
          to_return(status: 200, body: find_contrato_by_id_reponse, headers: {})
      end

      it 'retrieves contrato by id' do
        contrato = Superlogica::Contrato.find(1222)

        expect(contrato.id).to eq 1222
      end
    end
  end

  describe '.all' do
    context 'when call .all' do
      all_contrato_json_response = File.read("spec/fixtures/api/superlogica/" \
                                         "contrato_all.json")
      
      before(:each) do        
       stub_request(:get, "https://apps.superlogica.net/imobiliaria/api/contratos").
         with(
           headers: {
          'Accept'=>'application/json',
          'Connection'=>'close',
          'Content-Type'=>'application/json',
          'Host'=>'apps.superlogica.net',
          'User-Agent'=>'http.rb/4.4.1'
           }).
         to_return(status: 200, body: all_contrato_json_response, headers: {})
      end

      it 'returns an array of Contrato objects' do
        contratos = Superlogica::Contrato.all
        contrato = contratos.first

        expect(contratos.class).to eq Array
        expect(contrato.class).to eq Superlogica::Contrato
      end
    end
  end  
end
