# frozen_string_literal: true

describe ZendeskEvent do
  describe 'tickets/new' do
    it 'notifies alpop_integration when a new ticket is created' do
      get '/api/v1/zendesk/events/tickets/new'
      expect(last_response).to be_ok
    end
  end

  describe 'tickets/:id/update' do
    it 'notifies alpop_integration when a ticket is updated' do
      get '/api/v1/zendesk/events/tickets/:id/update'
      expect(last_response).to be_ok
    end
  end

  describe 'tickets/:id/delete' do
    it 'notifies alpop_integration when a ticket is deleted' do
      get '/api/v1/zendesk/events/tickets/:id/delete'
      expect(last_response).to be_ok
    end
  end
end
