# frozen_string_literal: true

# Base class for Ruby API objects.
class Base
  def self.find(func, http_method, params)
    klass = to_s

    api = klass.split('::')[0]
    api = api.downcase

    object = klass.split('::')[1]
    object = object.downcase

    query = @query_builder.build(api, object, func, params)

    response = @middleware.do_request(api, query, http_method)
    response.body
  end
end
