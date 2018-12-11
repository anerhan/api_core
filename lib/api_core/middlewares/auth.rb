# INFO: This class using config/settings.yml paths part
# INFO: for provide Warden user strategies authenticate
module ApiCore
  module Middlewares
    class Auth
      def detect_path(env)
        meth = env['REQUEST_METHOD']
        path = env['PATH_INFO']
        namespace = ApiCore.config.namespace.present? ? ApiCore.config.namespace : '/'
        ApiCore.config.paths.detect do |path_info|
          meth == path_info['method'] && path.match(/\A#{File.join(namespace, path_info['path'])}\z/)
        end
      end

      def initialize(app)
        @app = app
      end

      def call(env)
        unless env['REQUEST_METHOD'] == 'OPTIONS'
          detected_path = detect_path(env)
          if detected_path && detected_path['scope']
            env['warden'].authenticate!(detected_path['scope'].to_sym)
          else
            env['warden'].authenticate!(scope: :default)
          end
        end
        @app.call(env)
      end
    end
  end
end
