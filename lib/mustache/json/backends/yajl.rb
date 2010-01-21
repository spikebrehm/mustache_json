require 'yajl' unless defined?(Yajl)

class Mustache
  module JSON
    module Backends
      class Yajl
        def self.encode(object)
          ::Yajl::Encoder.encode(object)
        end
      end
    end
  end
end