# frozen_string_literal: true

require 'parser'
require 'pipefy/card'

# Parser to process Pipefy Card responses.
class PipefyCardParser < Parser
  def self.parse_find(response)
    id = response['data']['card']['id']
    title = response['data']['card']['title']

    Pipefy::Card.new(id, title)
  end

  def self.parse_create(response)
    card = response['data']['createCard']['card']
    id = card['id']
    title = card['title']

    Pipefy::Card.new(id, title)
  end

  def self.parse_all(response)
    nodes = response['data']['cards']['edges']
    cards = []

    nodes.each do |node|
      id = node['id']
      title = node['title']
      card = Pipefy::Card.new(id, title)
      cards << card
    end
    cards
  end
end
