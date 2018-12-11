module ApiCore
  module Warden
    module Strategies
      class Public < Base
        def valid?
          true
        end

        def authenticate!
          success! true
        end
      end
    end
  end
end
