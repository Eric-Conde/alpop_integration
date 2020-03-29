# frozen_string_literal: true

require 'singleton'
require 'yaml'
require 'json'
require 'uri'
require 'net/http'

# Middleware is responsible for credentials, apis and requests.
class Middleware
  include Singleton

  # Constants.
  CONFIG_PATH = 'config/'

  APIS_YML_FILE = 'apis.yml'
  APIS_YML_PATH = CONFIG_PATH + APIS_YML_FILE

  CREDENTIALS = 'credentials.yml'
  CREDENTIALS_PATH = CONFIG_PATH + CREDENTIALS

  # Attr accessors
  attr_accessor :apis, :credentials

  def initialize
    @apis = Middleware.load_apis
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
    def load_apis
      apis = yml2hash(APIS_YML_PATH)
      apis['apis']
    end

    def load_credentials
      credentials = yml2hash(CREDENTIALS_PATH)
      credentials['credentials']
    end

    def yml2hash(yml_path)
      file = File.read(yml_path)
      yml_file = YAML.safe_load(file)
      yml_seriealized = yml_file.inspect
      JSON.parse yml_seriealized.gsub('=>', ':')
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
    apis_api = @apis[api]

    host = apis_api['config']['host']
    access_token = credentials_api['access_token']
    content_type = apis_api['content_type']
    app_token = credentials_api['app_token']

    [host, access_token, content_type, app_token]
  end
end
