require 'toml'

module AppInsights
  class ConfigLoader
    attr_reader :settings, :filename

    def initialize(root, filename = nil)
      @root = root
      @filename = filename || default_file
      @filename = File.join(@root, @filename) if @filename

      unless @filename && File.exist?(@filename)
        fail AppInsights::ConfigFileNotFound
      end

      @settings = TOML.load_file @filename

      AppInsights::Context.configure @settings['ai']
      AppInsights::Middlewares.configure @settings['middleware']
    end

    private

    def default_file
      default_paths.compact.find { |path| File.exist? File.join(@root, path) }
    end

    def default_paths
      @default_paths ||= [
        './config/application_insights.toml',
        './application_insights.toml',
        # ENV['AI_CONFIG_PATH']
      ]
    end
  end
end
