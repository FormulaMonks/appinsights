class MockTelemetryClient
  attr_reader :traces

  def initialize
    @traces = []
  end

  def track_trace(message, severity)
    @traces << [message, severity]
  end
end
