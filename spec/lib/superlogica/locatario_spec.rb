# frozen_string_literal: true

require 'superlogica/locatario'
require 'parser'

describe Superlogica::Locatario do  
  describe 'initializer' do
    context 'when Superlogica::Locatario is initialized' do
      it 'sets the locatario id' do
        locatario = build :locatario
        expect(locatario.id).not_to be_nil
      end

      it 'sets the locatario id_sacado_sac' do
        locatario = build :locatario
        expect(locatario.id_sacado_sac).not_to be_nil
      end
    end
  end

  describe '.find' do
    find_locatario_by_id = File.read("spec/fixtures/api/superlogica/" \
                                     "locatario_find.json")
    
    before(:each) do
      # Stub find cobranca by id to avoid HTTP requests.
      stub_request(:get, "https://apps.superlogica.net/imobiliaria/api/locatarios?id=18721").
         with(
           headers: {
          'Connection'=>'close',
          'Host'=>'apps.superlogica.net',
          'User-Agent'=>'http.rb/4.4.1'
           }).
         to_return(status: 200, body: find_locatario_by_id, headers: {})
    end


    context 'when call .find' do
      it 'retrieves a Locatario by id' do
        locatario = Superlogica::Locatario.find(18721)

        expect(locatario.id).to eq '18721'
      end
    end
  end

  describe '.ativos' do
    locatarios_ativos =  File.read("spec/fixtures/api/superlogica/" \
                                   "locatario_ativos.json")

    before(:each) do
       stub_request(:get, "https://apps.superlogica.net/imobiliaria/api/locatarios?statusContrato=locados").
          with(
            headers: {
            'Connection'=>'close',
            'Host'=>'apps.superlogica.net',
            'User-Agent'=>'http.rb/4.4.1'
            }).
          to_return(status: 200, body: locatarios_ativos, headers: {})
    end

    context 'when call .ativos' do
      it 'retrieves locatarios ativos' do
        ativos = Superlogica::Locatario.ativos
        ativo = ativos.first
        expect(ativo.active).to eq true
      end
    end
  end

  describe '.inadimplentes' do
    cobrancas_atrasadas =  File.read("spec/fixtures/api/superlogica/" \
                                     "cobranca_atrasadas.json")

    before(:each) do
       stub_request(:get, "https://apps.superlogica.net/imobiliaria/api/cobrancas?dtFim=&dtInicio=&itensPorPagina=500&status=pendentes").
         with(
           headers: {
          'Connection'=>'close',
          'Host'=>'apps.superlogica.net',
          'User-Agent'=>'http.rb/4.4.1'
           }).
         to_return(status: 200, body: cobrancas_atrasadas, headers: {})
    end

    context 'when call .inadimplentes' do
      it 'retrieves locatarios with 3 or more overdue cobrancas' do
        inadimplentes = Superlogica::Locatario.inadimplentes
        inadimplente = inadimplentes.first

        expect(inadimplentes).to be_instance_of(Array)
        expect(inadimplente.cobrancas_atrasadas).to be >= 3
      end
    end
  end
end