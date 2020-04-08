# frozen_string_literal: true

require 'base_helper'

# Base class for Ruby API objects.
class Base
  def self.find(func, http_method, params)
    klass = to_s
    api, object = get_api_and_caller_object_name(klass)
    api = api.downcase
    object = object.downcase
    query = @query_builder.build(api, object, func, params)
    response = @middleware.do_request(api, query, http_method)
    response.body
  end

  def self.all(func, http_method)
    klass = to_s
    api, object = get_api_and_caller_object_name(klass)
    api = api.downcase
    object = object.downcase
    query = @query_builder.build(api, object, func)
    response = @middleware.do_request(api, query, http_method)
    response.body
  end
end
