require 'json/pure' unless defined?(::JSON)

class Mustache
  module JSON
    module Backends
      class JsonPure
        def self.encode(object)
          ::JSON.generate(object)
        end
      end
    end
  end
end