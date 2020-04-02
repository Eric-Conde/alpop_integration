# frozen_string_literal: true

require 'base'
require 'middleware'
require 'query_builder'
require 'parser/pipefy_phase_parser'

# Pipefy module.
module Pipefy
  # Phase is a ruby representation of Pipefy Phase.
  class Phase < Base
    API = 'pipefy'

    attr_accessor :id

    @middleware = Middleware.instance
    @query_builder = QueryBuilder.new

    def initialize(id = nil)
      @id = id
    end

    def self.find(id)
      response_body = super('find', 'POST', { id: id })
      Parser.parse(API, 'Phase', response_body, 'find')
    end
  end
end
