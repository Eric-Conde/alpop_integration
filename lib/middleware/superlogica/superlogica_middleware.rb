# frozen_string_literal: true

require 'middleware'

# Middleware specific functions to integrates with Superlogica API.
class SuperlogicaMiddleware < Middleware
  def initialize
    super
  end

  private

  def config_header(access_token, content_type)
    headers = super
    app_token = seek_api('superlogica')[3]
    headers[:app_token] = app_token
    headers
  end
end
