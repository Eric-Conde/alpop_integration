# frozen_string_literal: true

require 'parser/pipefy_phase_parser'

describe PipefyPhaseParser do
  context '.parse_find(response)' do
    context 'when calls parse_find(response)' do
      it 'returns a phase with id' do
        phase_json_response = '{"data": {"phase": {"id": "22"}}}'

        phase = Parser.parse('pipefy', 'Phase', phase_json_response, 'find')

        expect(phase.id).not_to be_nil
        expect(phase.id).to eq 22
      end
    end
  end
end
