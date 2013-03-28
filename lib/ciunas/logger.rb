module Ciunas
  class Logger < Rails::Rack::Logger
    def initialize(app, opts = {})
      @app = app
      @silenced = opts.delete(:silenced) || []
      super
    end

    def call(env)
      # FATAL + 1 ensures that 404 errors are not logged
      old_logger_level = Rails.logger.level
      Rails.logger.level = ::Logger::FATAL + 1 if env['X-SILENCE-LOGGER'] || @silenced.any? {|m| m === env['PATH_INFO'] }
      super
    ensure
      Rails.logger.level = old_logger_level
    end
  end
end
