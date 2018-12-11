module ApiCore
  module Middlewares
    class Localize
      def initialize(app)
        @app = app
      end

      def apply_locale(env)
        return unless env['HTTP_ACCEPT_LANGUAGE']
        header_locale = env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/)&.first&.downcase
        return unless header_locale
        locale = ApiCore.config.i18n['locales'].detect { |_k, l| l['aliases'].include?(header_locale) }
        return unless locale
        I18n.locale = locale[0]
      end

      def call(env)
        apply_locale(env)
        @app.call(env)
      end
    end
  end
end
