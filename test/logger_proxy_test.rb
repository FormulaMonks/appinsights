require 'application_insights'
require_relative 'mock/mock_logger'
require_relative 'mock/mock_telemetry_client'

describe AppInsights::LoggerProxy do
  before do
    @client = MockTelemetryClient.new
    @logger = MockLogger.new
  end

  describe 'log' do
    it 'sends traces to AppInsights' do
      proxy = AppInsights::LoggerProxy.new(@logger, false, @client)
      proxy.level = :info

      proxy.info('a info message')

      assert_equal 1, @logger.messages.length
      assert_equal [Logger::INFO, nil, 'a info message'], @logger.messages.first[0, 3]
      assert_equal 1, @client.traces.length
      assert_equal ['a info message', ApplicationInsights::Channel::Contracts::SeverityLevel::INFORMATION], @client.traces.first
    end

    it 'does not send traces to AppInsights if the log level is too low' do
      proxy = AppInsights::LoggerProxy.new(@logger, false, @client)
      proxy.level = :warn

      proxy.debug('a debug message')

      assert @client.traces.empty?
    end

    it 'sends traces to AppInsights for low log level when telemetry sending is forced' do
      proxy = AppInsights::LoggerProxy.new(@logger, true, @client)
      proxy.level = :warn

      proxy.debug('a debug message')

      assert_equal 1, @client.traces.length
      assert_equal ['a debug message', ApplicationInsights::Channel::Contracts::SeverityLevel::VERBOSE], @client.traces.first
    end
  end
end
