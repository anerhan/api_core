module ApiCore
  module Loggers
    class Custom < Simple
      def format_message(_severity, timestamp, _progname, msg)
        "[#{timestamp.strftime('%Y-%m-%d %H:%M:%S')}] - #{msg}\n"
      end
    end
  end
end
