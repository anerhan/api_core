module ApiCore
  module Warden
    module Strategies
      class Oauth2 < Base
        def valid?
          oauth_token.present?
        end

        def authenticate!
          fail!('sign_required') && return unless x_sign
          user = ApiCore::Models::User.find(oauth_token)
          fail!('user_is_not_authorized_for_access_token') && return unless user
          fail!('invalid_sign') && return if user.sign != x_sign
          success!(user)
        end
      end
    end
  end
end
