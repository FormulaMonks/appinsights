require 'application_insights'

module AppInsights
  class Context
    class << self
      def configure(config = {})
        if config.fetch('async', false)
          sender = ApplicationInsights::Channel::AsynchronousSender.new
          sender.send_interval = config.fetch('async_send_interval_seconds', 60)
          sender.send_buffer_size = config.fetch('async_send_buffer_size', 100)
          queue = ApplicationInsights::Channel::AsynchronousQueue.new sender
          queue.max_queue_length = config.fetch('async_max_queue_length', 500)
          channel = ApplicationInsights::Channel::TelemetryChannel.new(nil, queue)
          @client = ApplicationInsights::TelemetryClient.new(nil, channel)
        end

        @context = telemetry_client.context

        contracts.each do |contract|
          instance = configure_contract(contract.capitalize, config)
          @context.send :"#{contract}=", instance
        end

        @context.instrumentation_key = config['instrumentation_key']
        @context.properties = extract_custom_properties config

        @context
      end

      def telemetry_client
        @client ||= ApplicationInsights::TelemetryClient.new
      end

      def context
        @context
      end

      private

      def configure_contract(contract, config)
        const = ApplicationInsights::Channel::Contracts.const_get contract

        const.new config[contract.downcase]
      rescue NameError
        nil
      end

      # Custom properties are defined at [ai] level of the config file.
      def extract_custom_properties(config)
        config.reject { |k, v| k.to_s == 'instrumentation_key' || v.is_a?(Hash) }
      end

      def contracts
        %w(user device session location operation application)
      end
    end
  end
end
