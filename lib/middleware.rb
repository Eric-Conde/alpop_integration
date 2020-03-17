# frozen_string_literal: true

require 'singleton'
require 'yaml'
require 'json'

# Middleware is responsible for credentials, apis and requests.
class Middleware
  include Singleton

  # Constants.
  CONFIG_PATH = 'config'

  APIS_YML_FILE = 'apis.yml'
  APIS_YML_PATH = CONFIG_PATH + '/' + APIS_YML_FILE

  ACCESS_TOKENS_YML_FILE = 'access_tokens.yml'
  ACCESS_TOKENS_YML_PATH = CONFIG_PATH + '/' + ACCESS_TOKENS_YML_FILE

  # Attr accessors
  attr_accessor :apis, :access_tokens

  def initialize
    @apis = Middleware.load_apis
    @access_tokens = Middleware.load_access_tokens
  end

  def do_request(api, query, http_method = 'GET')
    host, authorization_key, content_type = seek_api(api)

    url = URI(host)

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = do_post(url, query) if http_method == 'POST'
    request = do_get(url, query) if http_method == 'GET'

    request['authorization'] = authorization_key
    request['content-type'] = content_type

    http.request(request)
  end

  def self.load_apis
    apis = yml2hash(APIS_YML_PATH)
    apis['apis']
  end

  def self.load_access_tokens
    access_tokens = yml2hash(ACCESS_TOKENS_YML_PATH)
    access_tokens['access_tokens']
  end

  def self.yml2hash(yml_path)
    file = File.read(yml_path)
    yml_file = YAML.safe_load(file)
    yml_seriealized = yml_file.inspect
    JSON.parse yml_seriealized.gsub('=>', ':')
  end

  private

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
    host = @apis[api]['config']['host']
    authorization_key = @access_tokens[api]['key']
    content_type = @apis[api]['content_type']

    [host, authorization_key, content_type]
  end
end
