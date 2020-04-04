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
    end
  end

  describe '.find' do
    find_locatario_by_id = File.read("spec/fixtures/api/superlogica/" \
                                     "locatario_find.json")
    
    before(:each) do
      # Stub find cobranca by id to avoid HTTP requests.
      stub_request(:get, "https://apps.superlogica.net:80/imobiliaria/api/locatarios?id=18721").
         with(
           headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Access-Token'=>'put_here_your_credentials',
          'Authorization'=>'put_here_your_credentials',
          'Host'=>'apps.superlogica.net',
          'User-Agent'=>'Ruby'
           }).
         to_return(status: 200, body: find_locatario_by_id, headers: {})
    end


    context 'when call .find()' do
      it 'retrieves a Locatario by id' do
        cobranca = Superlogica::Locatario.find(18721)

        expect(cobranca.id).to eq 18721
      end
    end
  end

  describe '.all' do
  end

  describe '.ativos' do
  end

  describe '.inativos' do
  end
end