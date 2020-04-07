# frozen_string_literal: true

require 'middleware'
require 'yaml'

describe Middleware do
  let(:middleware) { Middleware.instance }

  context 'initializer' do
    it 'must load endpoints configs' do
      # Load YML.
      catalog_yml_file = File.read('config/catalog.yml')
      catalog_yml = YAML.safe_load(catalog_yml_file)

      # Load YML as a Hash.
      yml_seriealized = catalog_yml.inspect
      catalog = JSON.parse yml_seriealized.gsub('=>', ':')

      # Expected values.
      expected_loaded_apis = catalog['catalog'].size

      # Expectations.
      middleware_catalog = middleware.catalog
      expect(middleware_catalog.size).to eq expected_loaded_apis
    end

    it 'must load access tokens' do
      # Load YML.
      credentials_yml_file = File.read('config/credentials.yml')
      credentials_yml = YAML.safe_load(credentials_yml_file)
      # Load YML as a Hash.
      yml_seriealized = credentials_yml.inspect
      credentials = JSON.parse yml_seriealized.gsub('=>', ':')

      # Expected values.
      expected_loaded_credentials = credentials['credentials'].size

      # Expectations.
      middleware_credentials = middleware.credentials
      expect(middleware_credentials.size).to eq expected_loaded_credentials
    end

    it 'is a singleton' do
      expect(Middleware.respond_to?(:new)).to be false
    end
  end

  context '.do_request' do
    before(:each) do
      # Simulate the API response for find a card by id.
      find_card_by_id_response = '{"data":{"card":{"pipe":{"id":"1182718"},
      "title":"Oséias "}}}'

      # Stub find card by id to avoid HTTP requests.
      stub_request(:post, "https://api.pipefy.com/graphq").
         with(
           headers: {
          'Connection'=>'close',
          'Host'=>'api.pipefy.com',
          'User-Agent'=>'http.rb/4.4.1'
           }).
         to_return(status: 200, body: find_card_by_id_response, headers: {})

       stub_request(:get, "https://api.pipefy.com/graphqwhatever").
         with(
           headers: {
          'Connection'=>'close',
          'Host'=>'api.pipefy.com',
          'User-Agent'=>'http.rb/4.4.1'
           }).
         to_return(status: 200, body: find_card_by_id_response, headers: {})
    end

    it 'does a GET request' do
      api = 'pipefy'
      query = 'whatever'

      http_method = 'GET'
      response = middleware.do_request(api, query, http_method)

      expect(response.code).to eq 200
    end

    it 'does a POST request' do
      api = 'pipefy'
      query = 'whatever'

      http_method = 'POST'
      response = middleware.do_request(api, query, http_method)

      expect(response.code).to eq 200
    end

    it 'does a request to an API with status 200' do
      api = 'pipefy'
      query = 'whatever'

      http_method = 'POST'
      response = middleware.do_request(api, query, http_method)

      expect(response.code).to eq 200
    end
  end
end
