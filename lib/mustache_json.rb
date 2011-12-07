require 'mustache'

class Mustache
  # An array of methods that should be used for serialization.
  # By default it is all public instance methods defined on the
  # specific class (no superclasses). Override this for more
  # specific control.
  def self.serializable_methods
    public_instance_methods(false)
  end
  
  # A hash of the compiled Mustache, including all
  # serializable methods as well as the specified context.
  def serializable_hash
    hash = self.class.serializable_methods.inject({}) do |result, method|
      # Symbolize the method to work better with the Mustache Context.
      result[method.to_sym] = self.send(method)
      result
    end
    
    # hash.merge!(context)
  end
  
  # Convert the current Mustache object to JSON and
  # provide optional additional context for the result.
  def to_json(additional_context = {})
    hash = serializable_hash
    hash.merge!(additional_context)
    Mustache::JSON.encode(hash)
  end
  
  module JSON
    def self.backend #:nodoc:
      self.backend = :json_gem unless defined?(@backend)
      @backend
    end
    
    # Set the back-end for the JSON encoder in a swappable fashion.
    # Currently supported backends:
    #
    # * <tt>:json_gem</tt>
    # * <tt>:json_pure</tt>
    # * <tt>:active_support</tt>
    # * <tt>:yajl</tt>
    #
    # The default backend is the JSON gem.
    def self.backend=(backend)
      if backend.is_a?(Class)
        @backend = backend
      else
        require "mustache/json/backends/#{backend.to_s.downcase}.rb"
        @backend = class_for(backend)
      end
    end
    
    # Generic JSON encoder that will use the specified back-end.
    def self.encode(object)
      self.backend.encode(object)
    end
    
    def self.class_for(backend)#:nodoc:
      class_name = backend.to_s.split('_').map(&:capitalize).join('')
      eval "Mustache::JSON::Backends::#{class_name}"
    end
  end
end