# frozen_string_literal: true

require 'base'
require 'parser/zendesk_user_parser'


# Zendesk module.
module Zendesk
  API = 'zendesk'

  # Zendesk User ruby object.
  class User < Base
    attr_accessor :id
    
    def initialize(id = nil)
      @id = id
    end

    def self.find(id)
      response_body = super('GET', { id: id })
    end
  end
end
