module AppInsights
  class Railtie < Rails::Railtie
    initializer 'ai_agent.start_plugin' do |_app|
      begin
        AppInsights::ConfigLoader.new Rails.root

        AppInsights::Middlewares.enabled.each do |middleware, args|
          config.app_middleware.use middleware, *args.values
        end
      rescue AppInsights::ConfigFileNotFound => e
        Rails.logger.error e.message
        Rails.logger.info <<-EOS
          Place your config file `application_insights.toml` into your rails
          application under the `config` directory.
        EOS
      end
    end
  end
end
