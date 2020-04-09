# frozen_string_literal: true

require 'base'
require 'middleware'
require 'query_builder'
require 'parser/pipefy_card_parser'

# Pipefy module.
module Pipefy
  # Card is a ruby representation of Pipefy Card.
  class Card < Base
    API = 'pipefy'

    attr_accessor :id, :title

    def initialize(id = nil, title = nil)
      @title = title
      @id = id
    end

    def self.find(id)
      response_body = super('POST', { id: id })
    end

    def self.all(pipe_id = nil)
      response_body = super('POST', { pipe_id: pipe_id })
    end

    def self.create(params)
      response_body = super('POST', params)
    end
  end
end
