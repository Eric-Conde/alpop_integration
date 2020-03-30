# frozen_string_literal: true

module Pipefy
  # Pipe is a ruby representation of Pipefy Pipe.
  class Pipe
    API = 'pipefy'

    attr_accessor :id

    def initialize(id = nil)
      @id = id
    end
  end
end
