require 'application_insights'

module AppInsights
  class LoggerProxy < Object
    @@severity_levels = {
      :debug => ApplicationInsights::Channel::Contracts::SeverityLevel::VERBOSE,
      :info => ApplicationInsights::Channel::Contracts::SeverityLevel::INFORMATION,
      :warn => ApplicationInsights::Channel::Contracts::SeverityLevel::WARNING,
      :error => ApplicationInsights::Channel::Contracts::SeverityLevel::ERROR,
      :fatal => ApplicationInsights::Channel::Contracts::SeverityLevel::CRITICAL,
      :unknown => ApplicationInsights::Channel::Contracts::SeverityLevel::CRITICAL,
    }

    def initialize(logger, ignore_log_level=false, telemetry_client=nil)
      @logger = logger
      @ignore_log_level = ignore_log_level
      @telemetry_client = telemetry_client

      %w(debug info warn error fatal unknown).each do |level|
        LoggerProxy.class_eval do
          define_method level.to_sym do |*args , &block|
            if !@ignore_log_level && !logger.send("#{level}?".to_sym)
              return true
            end

            msg = message(*args, &block)
            tc = @telemetry_client || AppInsights::Context.telemetry_client
            tc.track_trace(msg, @@severity_levels[level.to_sym])
            @logger.send(level, msg, &block)
          end
        end
      end
    end

    protected

    def method_missing(name, *args, &block)
      @logger.send(name, *args, &block)
    end

    private

    def message(*args, &block)
      if block_given?
        block.call
      else
        args = args.flatten.compact
        args = (args.count == 1 ? args[0] : args)
        args.is_a?(Proc) ? args.call : args
      end
    end

  end
end
