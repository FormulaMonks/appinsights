module AIAgent
  class Railtie < Rails::Railtie
    initializer 'ai_agent.start_plugin' do |app|
      require 'pry'; binding.pry
      AIAgent::Agent.configure app.config
    end
  end
end
