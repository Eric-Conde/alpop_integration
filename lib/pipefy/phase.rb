# frozen_string_literal: true

require 'base'
require 'parser/pipefy_phase_parser'

# Pipefy module.
module Pipefy
  # Phase is a ruby representation of Pipefy Phase.
  class Phase < Base
    API = 'pipefy'

    attr_accessor :id

    def initialize(id = nil)
      @id = id
    end

    def self.find(id)
      response_body = super('POST', { id: id })
    end
  end
end
