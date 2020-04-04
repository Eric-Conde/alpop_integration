# frozen_string_literal: true

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
    url = URI(host)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = do_post(url, query) if http_method == 'POST'
    request = do_get(url, query) if http_method == 'GET'

    request = config_header(request, access_token, content_type)

    http.request(request)
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

  def config_header(request, access_token, content_type)
    request['authorization'] = access_token
    request['content-type'] = content_type
    request['access_token'] = access_token

    request
  end

  def do_get(url, query)
    url += query
    Net::HTTP::Get.new(url)
  end

  def do_post(url, query)
    request = Net::HTTP::Post.new(url)
    request.body = query
    request
  end

  def seek_api(api)
    credentials_api = @credentials[api]
    catalog_api = @catalog[api]

    host = catalog_api['config']['host']
    access_token = credentials_api['access_token']
    content_type = credentials_api['content_type']
    app_token = credentials_api['app_token']

    [host, access_token, content_type, app_token]
  end
end
