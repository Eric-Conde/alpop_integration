# frozen_string_literal: true

# Loading event listeners.
require File.join(File.dirname(__FILE__), 'lib/api/v1/zendesk', 'event')
require File.join(File.dirname(__FILE__), 'lib/api/v1/pipefy', 'event')
require File.join(File.dirname(__FILE__), 'config', 'routes')

routes = Rack::URLMap.new({
                            '/api/v1/zendesk/events/' => ZendeskEvent,
                            '/api/v1/pipefy/events/' => PipefyEvent
                          })

run routes
