module AppInsights
  class BaseInstaller
    attr_accessor :app, :root, :filename, :logger

    def initialize(app, root, filename = nil, logger = nil)
      @app, @root, @filename, @logger = app, root, filename, logger
    end

    def install
      AppInsights::ConfigLoader.new @root, @filename

      AppInsights::Middlewares.enabled.each do |middleware, args|
        @app.use middleware, *args.values
      end
    rescue AppInsights::ConfigFileNotFound => e
      @logger.error e.message
      @logger.info config_file_not_found_message
    end

    def logger
      @logger ||= Logger.new STDOUT
    end

    private

    def config_file_not_found_message
      <<-EOS
        Place your config file `application_insights.toml`
        under the `config` or root directory of your application.
        Check the README for manual installation.
      EOS
    end
  end
end
