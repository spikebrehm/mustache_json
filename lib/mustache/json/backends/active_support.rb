require 'active_support/json' unless defined?(::ActiveSupport::JSON)

class Mustache
  module JSON
    module Backends
      class ActiveSupport
        def self.encode(object)
          ::ActiveSupport::JSON.encode(object)
        end
      end
    end
  end
end