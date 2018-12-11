module ApiCore
  module Models
    class User
      include Base

      attr_accessor :id, :access_token_id, :lifetime, :ws_token, :sign, :suspended, :position

      validates :id, numericality: true, presence: true
      validates :access_token_id, numericality: true, presence: true
      validates :lifetime, numericality: true, presence: true
      validates :ws_token, presence: true
      validates :sign, presence: true
      validates :position, presence: true

      def attributes
        super.merge(
          id: id,
          access_token_id: access_token_id,
          lifetime: lifetime,
          ws_token: ws_token,
          sign: sign,
          suspended: suspended,
          position: position
        )
      end

      def admin?
        position == 'admin'
      end

      def user?
        position == 'user'
      end

      # INFO: Living time is same like AccessToken
      def live_timeout
        lifetime
      end

      class << self
        def create_from_source!(user)
          return unless user&.current_access_token
          create!(
            id: user.id,
            key: user.current_access_token.access_token,
            access_token_id: user.current_access_token.id,
            lifetime: user.current_access_token.lifetime,
            ws_token: user.current_access_token.ws_token,
            sign: user.current_access_token.sign,
            suspended: user.suspended?,
            position: user.position
          )
        end
      end
    end
  end
end
