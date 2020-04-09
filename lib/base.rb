# frozen_string_literal: true

require 'middleware'
require 'parser'
require 'query_builder'
require 'base_helper'

# Base class for Ruby API objects.
class Base
  @@middleware = Middleware.instance
  @@query_builder = QueryBuilder.new

  def self.find(http_verb, params, format = nil)
    action = 'find'    
    response = get_response(action, http_verb, params)
    response = parse_response(action, response)
  end

  def self.all(http_verb, params = nil)
    action = 'all'
    response = get_response(action, http_verb, params)
    response = parse_response(action, response)
  end

  def self.create(http_verb, params = nil)
    action = 'create'
    response = get_response(action, http_verb, params)
    response = parse_response(action, response)
  end

  def self.middleware
    @@middleware
  end

  def self.query_builder
    @@query_builder
  end

  def self.build_query(api, object, action, params = nil)
    query_builder.build(api, object, action, params)
  end

  def self.do_request(api, query, http_verb)
    middleware.do_request(api, query, http_verb)
  end


  def self.get_response(action, http_verb, params)
    klass = to_s
    api = get_api(klass)
    object = get_object(klass)
    
    query = build_query(api, object, action, params)
    response = do_request(api, query, http_verb)
    response.body
  end

  def self.parse_response(action, response)
    klass = to_s
    api = get_api(klass)
    object = get_object(klass)
    
    Parser.parse(api, object.capitalize, response, action)
  end
end
