# frozen_string_literal: true

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rspec'
require 'support/factory_bot'
require 'webmock/rspec'
require 'rack/test'
require File.join(File.dirname(__FILE__), '../lib/api/v1/zendesk', 'event')
require File.join(File.dirname(__FILE__), '../lib/api/v1/pipefy', 'event')

ENV['RACK_ENV'] = 'test'

WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  config.order = 'random'
end

module RSpecMixin
  include Rack::Test::Methods
  def app
    Rack::URLMap.new({
                      '/api/v1/zendesk/events/' => ZendeskEvent,
                      '/api/v1/pipefy/events/' => PipefyEvent
                    })
  end
end

RSpec.configure { |c| c.include RSpecMixin }
