require_relative 'errors'
require_relative 'context'
require_relative 'middlewares'
require_relative 'config_loader'

module AppInsights
  if defined?(Rails::VERSION)
    require_relative 'frameworks/rails'
  else
    puts <<-EOS
      Config file not loaded.
      Use AppInsights::ConfigLoader.new root, filename
      to setup the Context and middlewares.
    EOS

    # Initialize for other frameworks
    #
    # loader = ConfigLoader.new __FILE__
  end
end
