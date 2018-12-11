module ApiCore
  module Warden
    module Strategies
      class Base < ::Warden::Strategies::Base
        def oauth_token
          request.env['HTTP_AUTHORIZATION'].try(:sub, /\AOAuth\s/, '')
        end

        def x_sign
          request.env['HTTP_X_SIGN']
        end

        def x_device_id
          request.env['HTTP_X_DEVICE_ID']
        end

        def user_agent
          request.env['HTTP_USER_AGENT']
        end

        # INFO: Sign builded by UserAgent & DeviceID
        def sign
          return unless user_agent || x_device_id
          ApiCore::Base.build_sign([user_agent, x_device_id])
        end
      end
    end
  end
end
