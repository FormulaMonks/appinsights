module ApplicationInsightsInstaller
  class ConfigLoader
    attr_reader :settings, :filename

    def initialize(root, filename = nil)
      @root = root
      @filename = filename || default_file

      fail ApplicationInsightsInstaller::ConfigFileNotFound unless @filename

      @settings = TOML.load_file @filename

      Context.configure @settings['ai']
      Middlewares.configure @settings['middleware']
    end

    private

    def default_file
      default_paths.compact.find { |path| File.exist? path }
    end

    def default_paths
      @default_paths ||= [
        File.join(@root, './config/application_insights.toml'),
        File.join(@root, './application_insights.toml'),
        # ENV['AI_CONFIG_PATH']
      ]
    end
  end
end
