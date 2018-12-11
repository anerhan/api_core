module ApiCore
  module Models
    module Base
      extend ActiveSupport::Concern

      include ActiveModel::Model
      include ActiveModel::Serialization

      included do
        attr_writer :created_at, :type
        attr_accessor :id, :key

        validates :key, presence: true
      end

      def created_at
        @created_at ||= Time.now
      end

      def destroy
        ApiCore.config.redis_secure.del(key)
        self
      end

      def type
        @type ||= self.class.name
      end

      def create_or_update
        return unless valid?
        ApiCore.config.redis_secure.set(self.class.encrypt_key(key), attributes.to_json)
        ApiCore.config.redis_secure.expire(self.class.encrypt_key(key), live_timeout.to_i)
        true
      end

      def save!
        create_or_update || raise(ApiCore::Errors::ActiveModel::RecordInvalid, self)
        after_save
      end

      def attributes
        {
          'key' => key,
          'created_at' => @created_at,
          'type' => type
        }
      end

      def live_timeout
        1.month
      end

      def lifetime
        lifetime = created_at - live_timeout.ago
        lifetime.positive? ? lifetime.abs.round : 0
      end

      def after_save
        self
      end

      module ClassMethods
        def encrypt_key(key)
          ApiCore::Base.md5("#{salt}#{key}")
        end

        def salt
          'A8asf7ashljsfua09sflkflasfkas'
        end

        def create!(attrs = {})
          obj = new(attrs)
          obj.save!
          obj
        end

        def find(key)
          json = ApiCore.config.redis_secure.get(encrypt_key(key))
          return unless json
          new JSON.parse(json)
        end
      end
    end
  end
end
