require 'application_insights'

module ApplicationInsightsInstaller
  class ExceptionHandling
    def initialize(app)
      @app = app
    end

    def call(env)
      @app.call env
    rescue Exception => exception
      tc = ApplicationInsightsInstaller::Context.telemetry_client
      tc.track_exception exception

      raise exception
    end
  end
end
