# frozen_string_literal: true

require 'parser'
require 'pipefy/phase'

# Parser to process Pipefy Phase responses.
class PipefyPhaseParser < Parser
  def self.parse_find(response)
    id = response['data']['phase']['id'].to_i

    Pipefy::Phase.new(id)
  end
end
