require_relative 'helper'
require 'application_insights'

describe AppInsights::ConfigLoader do
  before do
    AppInsights::Context.tap do |klass|
      klass.instance_variable_set :@context, nil
      klass.instance_variable_set :@client, nil
    end

    AppInsights::Middlewares.tap do |klass|
      klass.instance_variable_set :@settings, nil
      klass.instance_variable_set :@enabled_middlewares, nil
    end
  end

  describe 'initialize' do
    it 'fails when there is no configuration file' do
      assert_raises AppInsights::ConfigFileNotFound do
        AppInsights::ConfigLoader.new '.'
      end
    end

    it 'loads the config file from the default path' do
      loader = AppInsights::ConfigLoader.new './test'

      deny loader.settings.empty?
    end

    it 'loads the config file from the given filename' do
      loader = AppInsights::ConfigLoader.new './test/config', 'non_default_file.toml'

      deny loader.settings.empty?
    end

    it 'loads the config file from the ENV variable' do
      ENV['AI_CONFIG_RPATH'] = 'test/config/non_default_file.toml'

      loader = AppInsights::ConfigLoader.new './'

      deny loader.settings.empty?

      ENV.delete 'AI_CONFIG_RPATH'
    end

    it 'autoconfigure the Context and middlewares' do
      tc = AppInsights::Context.telemetry_client
      settings = AppInsights::Middlewares.settings
      middlewares = AppInsights::Middlewares.enabled

      deny tc.context.instrumentation_key
      assert settings.empty?
      assert middlewares.empty?

      AppInsights::ConfigLoader.new './test'

      tc = AppInsights::Context.telemetry_client
      settings = AppInsights::Middlewares.settings
      middlewares = AppInsights::Middlewares.enabled

      assert tc.context.instrumentation_key
      deny settings.empty?
      deny middlewares.empty?
    end
  end
end
