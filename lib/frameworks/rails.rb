module ApplicationInsightsInstaller
  class Railtie < Rails::Railtie
    initializer 'ai_agent.start_plugin' do |_app|
      ConfigLoader.new Rails.root

      Middlewares.enabled.each do |middleware, args|
        config.app_middleware.use middleware, *args.values
      end
    end
  end
end
