# frozen_string_literal: true

require 'middleware'

# Middleware specific functions to integrates with Superlogica API.
class SuperlogicaMiddleware < Middleware
  def initialize
    super
  end

  private

  def config_header(request, access_token, content_type)
    super
    app_token = seek_api('superlogica')[3]
    request['app_token'] = app_token
    request
  end
end
