require 'toml'
require_relative 'errors'
require_relative 'context'
require_relative 'middlewares'
require_relative 'config_loader'

module ApplicationInsightsInstaller
  if defined?(Rails::VERSION)
    require_relative 'frameworks/rails'
  else
    # Initialize for other frameworks
    #
    # loader = ConfigLoader.new __FILE__
  end
end

