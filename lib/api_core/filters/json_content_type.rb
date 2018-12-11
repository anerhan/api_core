module ApiCore
  module Filters
    module JsonContentType
      def self.registered(app)
        app.before do
          content_type :json
          headers ApiCore.config.response_headers
        end
      end
    end
  end
end
