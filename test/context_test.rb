require_relative 'helper'

describe AppInsights::Context do
  before do
    @configs = {
      'instrumentation_key' => 'a_key',
      'custom' => 4,
      'properties' => 'belong to the context',
      'application' => {
        'ver' => '0.0.1'
      },
      'device' => {
        'id' => 'asdfghjkl1',
        'os' => 'OSX'
      }
    }
  end

  describe 'configure' do
    it 'returns a ApplicationInsights::Channel::TelemetryContext object' do
      context = AppInsights::Context.configure

      assert_equal ApplicationInsights::Channel::TelemetryContext, context.class
    end

    it 'accepts a hash to set Context values' do
      context = AppInsights::Context.configure @configs

      assert_equal 'a_key', context.instrumentation_key
      assert_equal '0.0.1', context.application.ver
    end
  end

  describe 'telemetry_client' do
    before do
      AppInsights::Context.configure @configs

      @client = AppInsights::Context.telemetry_client
    end

    it 'returns an instance of ApplicationInsights::TelemetryClient' do
      assert_equal ApplicationInsights::TelemetryClient, @client.class
    end

    it 'sets the context to the Telemetry Client' do
      assert_equal 'a_key', @client.context.instrumentation_key
    end
  end
end
