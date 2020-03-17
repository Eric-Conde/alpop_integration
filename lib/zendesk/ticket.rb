# frozen_string_literal: true

module Zendesk
  class Ticket
    attr_accessor :id

    def initialize(id = nil)
      @id = id
    end
  end
end