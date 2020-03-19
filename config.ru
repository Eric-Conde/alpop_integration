require 'bundler'
Bundler.require

require File.join(File.dirname(__FILE__),'lib', 'middleware')

MiddlewareApplication = Middleware.instance

# Load the routes
require File.join(File.dirname(__FILE__),'config', 'routes')

run Middleware.instance
