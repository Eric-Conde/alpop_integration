# frozen_string_literal: true

require 'sinatra'

# Event listener for Zendesk API.
class ZendeskEvent < Sinatra::Base
  get '/tickets/new' do
    '[Debug] - Ticket criado no Zendesk'
  end

  get '/tickets/:id/update' do
    '[Debug] - Ticket atualizado no Zendesk'
  end

  get '/tickets/:id/delete' do
    '[Debug] - Ticket removido no Zendesk'
  end
end
