module ApplicationInsightsInstaller
  class Railtie < Rails::Railtie
    initializer 'ai_agent.start_plugin' do |app|
      loader = ConfigLoader.new Rails.root

      Context.configure loader.settings['ai']
      Middlewares.configure loader.settings['middleware']

      Middlewares.enabled.each do |middleware, args|
        config.app_middleware.use middleware, *args.values
      end
    end
  end
end
