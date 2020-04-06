# frozen_string_literal: true

require 'http'
require 'middleware_helper'

# Middleware is responsible for credentials, API catalog and request/response.
class Middleware
  include Singleton

  # Constants.
  CONFIG_PATH = 'config/'

  CATALOG_FILE = 'catalog.yml'
  CATALOG_PATH = CONFIG_PATH + CATALOG_FILE

  CREDENTIALS = 'credentials.yml'
  CREDENTIALS_PATH = CONFIG_PATH + CREDENTIALS

  # Attr accessors
  attr_accessor :catalog, :credentials

  def initialize
    @catalog = Middleware.load_catalog
    @credentials = Middleware.load_credentials
  end

  def do_request(api, query, http_method = 'GET')
    host, access_token, content_type = seek_api(api)
    http = HTTP
    header = config_header(access_token, content_type)

    request = do_post(http, header, host, query) if http_method == 'POST'
    request = do_get(http, header, host, query) if http_method == 'GET'
    request
  end

  class << self
    def load_catalog
      catalog = yml2hash(CATALOG_PATH)
      catalog['catalog']
    end

    def load_credentials
      credentials = yml2hash(CREDENTIALS_PATH)
      credentials['credentials']
    end
  end

  private

  def config_header(access_token, content_type)
    { :accept => 'application/json', :access_token => access_token,
      'content-type' => content_type }
  end

  def do_get(http, headers, host, query)
    host += query
    http.headers(headers).get(host)
  end

  def do_post(http, headers, host, query)
    http.headers(headers).post(host, body: query)
  end

  def seek_api(api)
    credentials_api = @credentials[api]
    catalog_api = @catalog[api]
    host = catalog_api['config']['host']
    access_token = credentials_api['access_token']
    content_type = catalog_api['config']['content_type']
    app_token = credentials_api['app_token']

    [host, access_token, content_type, app_token]
  end
end
