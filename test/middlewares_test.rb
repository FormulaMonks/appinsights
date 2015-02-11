require_relative 'helper'

describe AppInsights::Middlewares do
  before do
    @configs = [
      {
        'name'    => 'AppInsights::ExceptionHandling',
        'enabled' => true
      },
      {
        'name'    => 'ApplicationInsights::Rack::TrackRequest',
        'enabled' => false
      }
    ]
  end

  after do
    AppInsights::Middlewares.tap do |klass|
      klass.instance_variable_set :@settings, nil
      klass.instance_variable_set :@enabled_middlewares, nil
    end
  end

  describe 'enabled' do
    it 'returns the middlewares enabled' do
      AppInsights::Middlewares.configure @configs

      enabled = AppInsights::Middlewares.enabled
      expected = [[AppInsights::ExceptionHandling, {}]]

      deny enabled.empty?
      assert_equal expected, enabled
    end

    it 'returns an empty Array if it was not configured' do
      assert AppInsights::Middlewares.enabled.empty?
    end
  end

  describe 'settings' do
    it 'returns the settings loaded' do
      AppInsights::Middlewares.configure @configs

      settings = AppInsights::Middlewares.settings

      deny settings.empty?
      assert_equal @configs, settings
    end

    it 'returns an empty Hash if it was not configured' do
      assert AppInsights::Middlewares.settings.empty?
    end
  end

  describe 'configure' do
    it 'accepts one or zero params' do
      AppInsights::Middlewares.configure

      assert_equal({}, AppInsights::Middlewares.settings)
      assert_equal([], AppInsights::Middlewares.enabled)
    end
  end
end
