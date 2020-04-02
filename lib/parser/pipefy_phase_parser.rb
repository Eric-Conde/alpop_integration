require 'parser'
require 'pipefy/phase'

class PipefyPhaseParser < Parser
  def self.parse_find(response)
    id = response['data']['phase']['id'].to_i

    Pipefy::Phase.new(id)
  end
end
