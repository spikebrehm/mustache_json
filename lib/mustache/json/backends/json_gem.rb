require 'json' unless defined?(::JSON)

class Mustache
  module JSON
    module Backends
      class JsonGem
        def self.encode(object)
          ::JSON.generate(object)
        end
      end
    end
  end
end