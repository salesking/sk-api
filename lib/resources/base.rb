module SKApi
  module Resources

    class Base < ActiveResource::Base
      include SKApi::Utils::Serializer
      self.format = :json # bug in AR must be set here
      # hook before init in activeresource base because json comes in nested:
        # {client={data}
        if ActiveResource::VERSION::MAJOR == 3 && ActiveResource::VERSION::MINOR > 0
          def initialize(attributes = {}, *args)
            attr = attributes[self.class.element_name] || attributes
            super(attr, *args)
          end
        else
          def initialize(attributes = {})
            attr = attributes[self.class.element_name] || attributes
            super(attr)
          end
        end

      # Define the connection to be used when talking to a salesking server
      def self.set_connection(opts)
        self.site     = opts[:site]
        self.user     = opts[:user]
        self.password = opts[:password]
        self.format   = opts[:format].to_sym
      end

    end
  end
end