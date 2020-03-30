# frozen_string_literal: true

require 'middleware/superlogica/superlogica_middleware'
require 'yaml'

describe SuperlogicaMiddleware do
  let(:superlogica_middleware) { SuperlogicaMiddleware.instance }

  context 'initializer' do
    it 'calls super' do
      expect(superlogica_middleware.catalog).not_to be_nil
      expect(superlogica_middleware.credentials).not_to be_nil
    end
  end

  context '.do_request' do
    let(:credentials) do
      # Load YML.
      credentials_yml_file = File.read('config/credentials.yml')
      credentials_yml = YAML.safe_load(credentials_yml_file)
      # Load YML as a Hash.
      yml_seriealized = credentials_yml.inspect
      credentials = JSON.parse(yml_seriealized.gsub('=>', ':'))['credentials']
    end

    let(:superlogica) { credentials['superlogica'] }

    before(:each) do
      stub_request(:get, "https://api.superlogica.net/v2/")
        .with(headers: {
                'Accept' => '*/*',
                'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                'Access-Token' => superlogica['access_token'],
                'App-Token' => superlogica['app_token'],
                'Authorization' => credentials['superlogica']['access_token'],
                'Host' => 'api.superlogica.net',
                'User-Agent' => 'Ruby'
              }).to_return(status: 200, body: '', headers: {})
    end

    it 'does a GET request' do
      api = 'superlogica'
      query = ''

      http_method = 'GET'
      response = superlogica_middleware.do_request(api, query, http_method)

      expect(response.code).to eq '200'
    end
  end
end
