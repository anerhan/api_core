require 'api_core/version'
require 'logger'
require 'yaml'
require 'i18n'
require 'active_record'
require 'warden'

require 'api_core/config'
require 'api_core/base'
require 'api_core/loggers/simple'
require 'api_core/loggers/custom'
require 'api_core/loggers/logging'

require 'api_core/errors/mapper'
require 'api_core/errors/unprocessible_entity'
require 'api_core/errors/active_model/record_invalid'

require 'api_core/filters/json_content_type'
require 'api_core/filters/json_exception'

require 'api_core/middlewares/failure_app'
require 'api_core/middlewares/localize'
require 'api_core/middlewares/auth'

require 'api_core/warden/strategies/base'
require 'api_core/warden/strategies/public'
require 'api_core/warden/strategies/oauth2'

require 'api_core/models/base'
require 'api_core/models/user'


module ApiCore
  class << self
    def configure(&_block)
      yield config
    end

    def config
      @config ||= Config.new
    end
  end
end

I18n.load_path += Dir[File.join(ApiCore.config.gem_root, 'config/locales', '**', '*.{rb,yml}')]
