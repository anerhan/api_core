module ApiCore
  module Loggers
    module Logging
      class << self
        def log_file
          log_file = File.new(File.join(ApiCore.config.root_path, 'log', "#{ApiCore.config.logger_prefix}.log"), 'a+')
          log_file.sync = true
          log_file
        end

        def logger
          Simple.new("#{ApiCore.config.logger_prefix}.log")
        end

        def tasks_logger
          Custom.new("#{ApiCore.config.logger_prefix}.tasks.log")
        end

        def workers_logger
          Custom.new("#{ApiCore.config.logger_prefix}.workers.log")
        end

        def service_logger
          Simple.new("#{ApiCore.config.logger_prefix}.service.log")
        end
      end
    end
  end
end
