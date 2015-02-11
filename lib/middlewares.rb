require_relative 'middlewares/exception_handling'

module ApplicationInsightsInstaller
  class Middlewares
    class << self
      def configure(settings = {})
        @settings = settings || {}
        @enabled_middlewares = constantize_middlewares
      end

      def enabled
        @enabled_middlewares || []
      end

      def settings
        @settings || {}
      end

      private

      def constantize_middlewares
        constants = @settings.map do |middleware|
          begin
            if middleware['enabled']
              c = const_get middleware['name']
              args = middleware['initialize'] || {}

              [c, args]
            end
          rescue NameError => e
            # FIXME: Log, ignore or fail?
            raise ApplicationInsightsInstaller::UnknownMiddleware, e.message
          end
        end

        constants.compact.uniq
      end
    end
  end
end
