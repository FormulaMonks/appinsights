require 'application_insights'

module AIAgent
  class ExceptionHandling
    def initialize(app)
      @app = app
    end

    def call(env)
      @app.call env
    rescue Exception => exception
      AIAgent::Context.telemetry_client.track_exception exception

      raise exception
    end
  end
end
