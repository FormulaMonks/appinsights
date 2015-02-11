require_relative 'helper'
require 'application_insights'

describe ApplicationInsightsInstaller::ConfigLoader do
  before do
    ApplicationInsightsInstaller::Context.tap do |klass|
      klass.instance_variable_set :@context, nil
      klass.instance_variable_set :@client, nil
    end

    ApplicationInsightsInstaller::Middlewares.tap do |klass|
      klass.instance_variable_set :@settings, nil
      klass.instance_variable_set :@enabled_middlewares, nil
    end
  end

  describe 'initialize' do
    it 'fails when there is no configuration file' do
      assert_raises ApplicationInsightsInstaller::ConfigFileNotFound do
        ApplicationInsightsInstaller::ConfigLoader.new '.'
      end
    end

    it 'loads the config file from the default path' do
      loader = ApplicationInsightsInstaller::ConfigLoader.new './test'

      deny loader.settings.empty?
    end

    it 'loads the config file from the given filename' do
      loader = ApplicationInsightsInstaller::ConfigLoader.new './test/config', 'non_default_file.toml'

      deny loader.settings.empty?
    end

    it 'autoconfigure the Context and middlewares' do
      tc = ApplicationInsightsInstaller::Context.telemetry_client
      settings = ApplicationInsightsInstaller::Middlewares.settings
      middlewares = ApplicationInsightsInstaller::Middlewares.enabled

      deny tc.context.instrumentation_key
      assert settings.empty?
      assert middlewares.empty?

      ApplicationInsightsInstaller::ConfigLoader.new './test'

      tc = ApplicationInsightsInstaller::Context.telemetry_client
      settings = ApplicationInsightsInstaller::Middlewares.settings
      middlewares = ApplicationInsightsInstaller::Middlewares.enabled

      assert tc.context.instrumentation_key
      deny settings.empty?
      deny middlewares.empty?
    end
  end
end
