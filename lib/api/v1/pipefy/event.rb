# frozen_string_literal: true

require 'sinatra'

# Event listener for Pipefy API.
class PipefyEvent < Sinatra::Base
  get '/cards/new' do
    '[Debug] - Card criado no Pipefy'
  end

  get '/cards/:id/update' do
    '[Debug] - Card atualizado no Pipefy'
  end

  get '/cards/:id/delete' do
    '[Debug] - Card removido no Pipefy'
  end
end
