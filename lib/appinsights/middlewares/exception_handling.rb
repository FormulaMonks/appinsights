require 'application_insights'

module AppInsights
  class ExceptionHandling
    def initialize(app)
      @app = app
    end

    def call(env)
      @app.call env
    rescue Exception => exception
      tc = AppInsights::Context.telemetry_client
      tc.track_exception exception

      raise exception
    end
  end
end
