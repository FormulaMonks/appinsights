require_relative 'appinsights/errors'
require_relative 'appinsights/context'
require_relative 'appinsights/middlewares'
require_relative 'appinsights/config_loader'
require_relative 'appinsights/installers/base'

module AppInsights
  if defined?(Rails::VERSION)
    require_relative 'appinsights/installers/rails'
  elsif defined?(Sinatra::VERSION)
    require_relative 'appinsights/installers/sinatra'
  else
    require 'logger'

    logger = Logger.new STDOUT
    logger.info <<-EOS
      Framework unknown, auto installation suspended.
      Use AppInsights::BaseInstaller.new app, root, filename
      to setup the Context and middlewares.
    EOS
  end
end
