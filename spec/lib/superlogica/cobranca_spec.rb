# frozen_string_literal: true

require 'superlogica/cobranca'
require 'parser'

describe Superlogica::Cobranca do
  find_cobranca_by_id = File.read("spec/fixtures/api/superlogica/" \
                                  "cobranca_find.json")

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
      stub_request(:get, "https://apps.superlogica.net/imobiliaria/api/cobrancas?id=651").
          with(
            headers: {
            'Connection'=>'close',
            'Host'=>'apps.superlogica.net',
            'User-Agent'=>'http.rb/4.4.1'
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
      cobranca_json_response = File.read("spec/fixtures/api/superlogica/" \
                                         "cobranca_all.json")
      
      before(:each) do        
       stub_request(:get, "https://apps.superlogica.net/imobiliaria/api/cobrancas").
         with(
           headers: {
          'Connection'=>'close',
          'Host'=>'apps.superlogica.net',
          'User-Agent'=>'http.rb/4.4.1'
           }).
         to_return(status: 200, body: cobranca_json_response, headers: {})
      end

      it 'returns an array of Cobranca objects' do
        cobrancas = Superlogica::Cobranca.all
        cobranca = cobrancas.first

        expect(cobrancas.class).to eq Array
        expect(cobranca.class).to eq Superlogica::Cobranca
      end
    end
  end

  describe '.pendentes' do
    before(:each) do
      pendentes_response = File.read("spec/fixtures/api/superlogica/" \
                                     "cobranca_pendentes.json")

      stub_request(:get, 'https://apps.superlogica.net/imobiliaria/api/' + 
                         'cobrancas?dtFim=:dtFim&dtInicio=:dtInicio&' + 
                         'itensPorPagina=500&status=pendentes').
         with(
           headers: {
          'Connection'=>'close',
          'Host'=>'apps.superlogica.net',
          'User-Agent'=>'http.rb/4.4.1'
           }).
         to_return(status: 200, body: pendentes_response, headers: {})
      end

    context 'when call pendentes' do
      it 'returns cobrancas pendentes' do
        cobranca_pendentes = Superlogica::Cobranca.pendentes
        cobranca_pendente = cobranca_pendentes.first
        expect(cobranca_pendente.id).not_to be_nil
      end
    end 
  end
end
