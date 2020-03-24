class Base
  def self.find(api, object, func, http_method, params)
    query = @query_builder.build(api, object, func, params)

    response = @middleware.do_request(api, query, http_method)
    body = response.body
  end
end
