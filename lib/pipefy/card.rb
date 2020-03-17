# frozen_string_literal: true

module Pipefy
  # Card is a ruby representation of Pipefy Card.
  class Card
    attr_accessor :title, :pipe_id

    def initialize(title = nil, pipe_id = nil)
      @title = title
      @pipe_id = pipe_id
    end
  end
end
