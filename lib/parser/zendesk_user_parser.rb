# frozen_string_literal: true

require 'parser'
require 'zendesk/user'

# Parser to process Zendesk User responses.
class ZendeskUserParser < Parser
  def self.parse_find(response)
    id = response['user']['id']
    Zendesk::User.new(id)
  end
end
