# frozen_string_literal: true

require 'pipefy/phase'

describe Pipefy::Phase do
  describe 'initializer' do
    context 'when Pipefy::Phase is initialized' do
      it 'sets phase id' do
        phase = build :phase
        expect(phase.id).not_to be_nil
      end
    end
  end

  describe '.find' do
    before(:each) do
      find_phase_by_id = '{"data":{"phase":{"id":2122}}}'

      # Stub find phase by id to avoid HTTP requests.
      stub_request(:post, /api.pipefy.com/)
        .with(headers: { 'Accept' => '*/*', 'User-Agent' => 'Ruby' })
        .to_return(status: 200, body: find_phase_by_id, headers: {})
    end

    context 'when call .find()' do
      it 'retrieves a Phase by id' do
        phase = Pipefy::Phase.find(2122)

        expect(phase.id).to eq 2122
      end
    end
  end
end
