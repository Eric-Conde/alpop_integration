# frozen_string_literal: true

describe PipefyEvent do
  describe 'cards/new' do
    it 'notifies alpop_integration when a new card is created' do
      get '/api/v1/pipefy/events/cards/new'
      expect(last_response).to be_ok
    end
  end

  describe 'cards/:id/update' do
    it 'notifies alpop_integration when a card is updated' do
      get '/api/v1/pipefy/events/cards/:id/update'
      expect(last_response).to be_ok
    end
  end

  describe 'cards/:id/delete' do
    it 'notifies alpop_integration when a card is deleted' do
      get '/api/v1/pipefy/events/cards/:id/delete'
      expect(last_response).to be_ok
    end
  end
end
