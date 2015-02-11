require 'toml'
require_relative 'errors'
require_relative 'context'
require_relative 'middlewares'
require_relative 'config_loader'

module ApplicationInsightsInstaller
  if defined?(Rails::VERSION)
    require_relative 'frameworks/rails'
  else
    loader = ConfigLoader.new __FILE__
    # Initialize for other frameworks
    Context.configure loader.settings['ai']
    Middlewares.configure loader.settings['middleware']
  end
end

