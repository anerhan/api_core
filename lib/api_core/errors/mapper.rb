module ApiCore
  module Errors
    class Mapper
      def self.error(opts = {})
        error = ApiCore.config.errors.detect { |m| m[:label] == opts[:label].to_s }
        error[:message]     = opts[:message] || I18n.t("error.#{error[:label]}")
        error[:string_code] = opts[:string_code] if opts[:string_code]
        error[:code]        = opts[:code]        if opts[:code]
        error
      end
    end
  end
end
