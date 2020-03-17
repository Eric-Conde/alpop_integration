# frozen_string_literal: true

require 'pipefy/pipe'

describe Pipefy::Pipe do
  describe 'initializer' do
    context 'when Pipefy::Pipe is initialized' do
      it 'must sets the pipe id' do
        pipe = build :pipe

        expect(pipe.id).not_to be_nil
      end
    end
  end
end
