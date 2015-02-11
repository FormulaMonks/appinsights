require_relative 'helper'

describe ApplicationInsightsInstaller::Middlewares do
  before do
    @configs = [
      {
        'name'    => 'ApplicationInsightsInstaller::ExceptionHandling',
        'enabled' => true
      },
      {
        'name'    => 'ApplicationInsights::Rack::TrackRequest',
        'enabled' => false
      }
    ]
  end

  after do
    ApplicationInsightsInstaller::Middlewares.tap do |klass|
      klass.instance_variable_set :@settings, nil
      klass.instance_variable_set :@enabled_middlewares, nil
    end
  end

  describe 'enabled' do
    it 'returns the middlewares enabled' do
      ApplicationInsightsInstaller::Middlewares.configure @configs

      enabled = ApplicationInsightsInstaller::Middlewares.enabled
      expected = [[ApplicationInsightsInstaller::ExceptionHandling, {}]]

      deny enabled.empty?
      assert_equal expected, enabled
    end

    it 'returns an empty Array if it was not configured' do
      assert ApplicationInsightsInstaller::Middlewares.enabled.empty?
    end
  end

  describe 'settings' do
    it 'returns the settings loaded' do
      ApplicationInsightsInstaller::Middlewares.configure @configs

      settings = ApplicationInsightsInstaller::Middlewares.settings

      deny settings.empty?
      assert_equal @configs, settings
    end

    it 'returns an empty Hash if it was not configured' do
      assert ApplicationInsightsInstaller::Middlewares.settings.empty?
    end
  end

  describe 'configure' do
    it 'accepts one or zero params' do
      ApplicationInsightsInstaller::Middlewares.configure

      assert_equal({}, ApplicationInsightsInstaller::Middlewares.settings)
      assert_equal([], ApplicationInsightsInstaller::Middlewares.enabled)
    end
  end
end
