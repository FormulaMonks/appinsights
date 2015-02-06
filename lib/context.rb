require 'application_insights'

module AIAgent
  class Context
    class << self
      def self.configure(config)
        @context = ApplicationInsights::Channel::TelemetryContext.new

        @context.user = extract_configs config, 'ai.user.'
        @context.device = extract_configs config, 'ai.device.'
        @context.session = extract_configs config, 'ai.session.'
        @context.location = extract_configs config, 'ai.location.'
        @context.operation = extract_configs config, 'ai.operation.'
        @context.application = extract_configs config, 'ai.application.'
        @context.instrumentation_key = config.delete :instrumentation_key
        @context.properties = config
      end

      def self.telemetry_client
        @client ||=
          ApplicationInsights::TelemetryClient.new.tap do |tc|
            tc.context = @context if @context
          end
      end

      private

      def extract_configs(config, key_prefix)
        config.delete_if { |k,v| k.to_s.start_with? key_prefix }
      end
    end
  end
end
