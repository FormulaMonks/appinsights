require_relative 'helper'
require_relative 'mock/mock_app'
require_relative 'mock/mock_logger'

describe AppInsights::Context do
  before do
    @app = MockApp.new
    @root = './test'
    @logger = MockLogger.new
  end

  describe 'install' do
    it 'logs an error if the config file is not found' do
      installer = AppInsights::BaseInstaller.new @app, @root, 'wrong_file', @logger

      assert @logger.messages.empty?

      installer.install

      deny @logger.messages.empty?
      assert_equal Logger::ERROR, @logger.messages.first.first
      assert_equal Logger::INFO, @logger.messages.last.first
    end

    it 'loads the configs from the file with no errors' do
      installer = AppInsights::BaseInstaller.new @app, @root, nil, @logger

      assert @logger.messages.empty?

      installer.install
      context = AppInsights::Context.context

      assert @logger.messages.empty?
      deny AppInsights::Middlewares.settings.empty?
      deny AppInsights::Middlewares.enabled.empty?
      assert_equal 'aaaaaaaa-aaaa-aaaa-aaaa', context.instrumentation_key
      assert_equal '0.2.0', context.application.ver
    end

    it 'register the middlewares automatically' do
      installer = AppInsights::BaseInstaller.new @app, @root, nil, @logger

      assert @app.middlewares.empty?

      installer.install

      deny @app.middlewares.empty?
    end
  end
end
