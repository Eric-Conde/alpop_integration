# frozen_string_literal: true

require 'base'
require 'parser/superlogica_contrato_parser'

# Superlogica module.
module Superlogica
  # Contrato is a ruby representation of Superlogica Contrato.
  class Contrato < Base
    API = 'superlogica'

    attr_accessor :id

    def initialize(id = nil)
      @id = id
    end

    def self.find(id)
      response_body = super('GET', { id: id })
    end

    def self.all
      response_body = super('GET')
    end
  end
end
