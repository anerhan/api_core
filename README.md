# ApiCore

Implement common strategies between all APIs:
- Warden
- Logging
- Filters
- Middlewares
- Base

## Installation

Add this line to your application's Gemfile:

    gem 'api_core'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install api_core


### Configuration in Sinatra APP

**Create config/initializers/api_core.rb with content:**
```
ApiCore.configure do |config|
  config.redis = Redis.new(url: Settings.redis.url)
  config.redis_secure = Redis.new(url: Settings.redis.secure_url)
  config.redis_bus = Redis.new(url: Settings.redis.bus_url)
  config.root_path = App.settings.root
  config.namespace = Settings.info.namespace
  config.logger_prefix = Settings.logger.prefix
end
```

## Usage

### Warden:

**Put config/paths.yml with content:**
This file using for MAP Warden strategies. Allowed from Gem: public, oauth2.
All unset paths will by processed by default strategy
```
---
- path: '/'
  method: GET
  scope: 'public'
```

**Modify application.rb**
```
# INFO: Authorization/Authentication
use Warden::Manager do |config|
  config.strategies.add :public, ApiCore::Warden::Strategies::Public
  config.strategies.add :oauth2, ApiCore::Warden::Strategies::Oauth2
  config.default_strategies %i[oauth2], scope: :default
  config.failure_app = ApiCore::Middlewares::FailureApp
end

use ApiCore::Middlewares::Localize
use ApiCore::Middlewares::Auth
```

### Logging:

**Modify application.rb**
```
use Rack::CommonLogger, ApiCore.config.common_log_file
```

### Filters:

**Modify application.rb**
```
register ApiCore::Filters::JsonContentType
register ApiCore::Filters::JsonException
```
