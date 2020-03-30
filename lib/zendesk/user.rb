# frozen_string_literal: true

require 'middleware'
require 'query_builder'
require 'base'

# Zendesk module.
module Zendesk
  API = 'zendesk'

  # Zendesk User ruby object.
  class User < Base
    attr_accessor :id

    @middleware = Middleware.instance
    @query_builder = QueryBuilder.new

    def initialize(id = nil)
      @id = id
    end

    def self.find(id)
      respose_body = super('find', 'GET', { id: id })
      User.parse(respose_body, 'find')
    end

    def self.parse(response, method)
      response = JSON.parse(response)
      method = "parse_#{method}"
      User.send(method, response)
    end

    def self.parse_find(response)
      user_id = response['user'] ['id']
      User.new(user_id)
    end
  end
end
