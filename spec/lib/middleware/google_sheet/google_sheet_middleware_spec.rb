# frozen_string_literal: true

require 'middleware/google_sheet/google_sheet_middleware'
require 'yaml'

describe GoogleSheetMiddleware do

  let(:google_sheet_middleware) { GoogleSheetMiddleware.instance }

  context 'initializer' do
    it 'calls super' do
      expect(google_sheet_middleware.apis).not_to be_nil
      expect(google_sheet_middleware.credentials).not_to be_nil
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

    let(:google_sheet) { credentials['google_sheet'] }

    before(:each) do
      spreadsheet_id = 'aaASdafSF23%23!daSAD'
      range = 'A1:A4'
      key = google_sheet['access_token']

      api_url = "https://sheets.googleapis.com/v4/" +
                "spreadsheets/#{spreadsheet_id}/values/#{range}?" +
                "key=#{key}"
      
      stub_request(:get, api_url)
        .with(headers: {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip,deflate',
          'Content-Type' => 'application/x-www-form-urlencoded',
          'User-Agent' => 'alpop_integration/0.0.0 google-api-ruby-client/0.37.2 Mac OS X/10.13.6 (gzip)',
          'X-Goog-Api-Client' => 'gl-ruby/2.7.0 gdcl/0.37.2'
        }).to_return(status: 200, body: '{ "code": 200 }', headers: {})
    end

    it 'does a GET request' do
      api = 'google_sheet'
      query = 'whatever'
      spreadsheet_id = 'aaASdafSF23#!daSAD'
      range = 'A1:A4'

      http_method = 'GET'
      response = JSON.parse(google_sheet_middleware
                              .do_request(spreadsheet_id, range))
      expect(response['code']).to eq 200
    end
  end
end
