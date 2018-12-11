module ApiCore
  module Loggers
    class Simple < Logger
      def initialize(file_basename)
        log_file = File.new(File.join(ApiCore.config.root_path, 'log', file_basename), 'a+')
        log_file.sync = true
        super(log_file)
      end

      def format_message(_severity, _timestamp, _progname, msg)
        "#{msg}\n"
      end
    end
  end
end
