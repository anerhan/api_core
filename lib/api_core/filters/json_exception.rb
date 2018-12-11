module ApiCore
  module Filters
    module JsonException
      def self.registered(app)
        # INFO: Common Error For all unprocessible entities
        app.error ApiCore::Errors::UnprocessibleEntity do
          err = ApiCore::Errors::Mapper.error(label: 'unprocessible_entity', message: env['sinatra.error'].message)
          [err[:code], ApiCore.config.response_headers, [{ errors: [{ code: err[:string_code], message: err[:message] }] }.to_json]]
        end

        # Bad Request
        app.error Sinatra::Param::InvalidParameterError do
          field = env['sinatra.error'].param
          [
            400,
            ApiCore.config.response_headers,
            [{ errors: [{ code: 'bad_request', message: "#{field.capitalize}: #{env['sinatra.error'].message}", field: field }] }.to_json]
          ]
        end

        # INFO: ActiveRecord/Model Errors handlers
        app.error ActiveRecord::RecordNotFound do
          err = ApiCore::Errors::Mapper.error(label: 'record_not_found', message: env['sinatra.error'].message)
          [
            err[:code],
            ApiCore.config.response_headers,
            [{ errors: [{ code: err[:string_code], message: env['sinatra.error'].message.gsub(/\s*\[WHERE[^\]]+\]/i, '') }] }.to_json]
          ]
        end

        app.error ApiCore::Errors::ActiveModel::RecordInvalid do
          [422, ApiCore.config.response_headers, [{
            errors:
              env['sinatra.error'].record.errors.messages.map do |field, messages|
                messages.map do |message|
                  { code: 'record_invalid', message: message, field: field }
                end
              end&.flatten&.uniq
          }.to_json]]
        end

        app.error ActiveRecord::RecordInvalid do
          [422, ApiCore.config.response_headers, [{
            errors:
              env['sinatra.error'].record.errors.messages.map do |field, messages|
                messages.map do |message|
                  { code: 'record_invalid', message: message, field: field }
                end
              end&.flatten&.uniq
          }.to_json]]
        end

        # INFO: GooglePlus Exceptions
        app.error GooglePlus::RequestError do
          err = ErrorMessagesMapper.error(label: 'unprocessible_entity', message: env['sinatra.error'].message)
          [err[:code], Settings.response_headers, [{ errors: [{ code: err[:string_code], message: err[:message] }] }.to_json]]
        end if defined?(GooglePlus)

        # INFO: Facebook Koala Exceptions
        app.error Koala::Facebook::AuthenticationError do
          err = ErrorMessagesMapper.error(label: 'unprocessible_entity', message: env['sinatra.error'].message)
          [err[:code], Settings.response_headers, [{ errors: [{ code: err[:string_code], message: err[:message] }] }.to_json]]
        end if defined?(Koala)
      end
    end
  end
end
