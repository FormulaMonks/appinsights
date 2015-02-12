require_relative 'errors'
require_relative 'context'
require_relative 'middlewares'
require_relative 'config_loader'

module AppInsights
  if defined?(Rails::VERSION)
    require_relative 'installers/rails'
  elsif defined?(Sinatra::VERSION)
    require_relative 'installers/sinatra'
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
