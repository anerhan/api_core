module ApiCore
  module Middlewares
    module FailureApp
      def self.call(env)
        label = env['warden'].message || env['warden.options'][:message] || 'unauthorized'
        if label.is_a?(Hash)
          return [
            label[:code],
            ApiCore.config.response_headers,
            label[:message].to_json
          ]
        end

        m = ApiCore::Errors::Mapper.error(label: label)
        [
          m[:code],
          ApiCore.config.response_headers,
          [{ errors: [{ code: m[:string_code], message: m[:message] }]}.to_json]
        ]
      end
    end
  end
end
