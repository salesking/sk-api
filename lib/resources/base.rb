module SKApi
  module Resources

    class Base < ActiveResource::Base
      include SKApi::Utils::Serializer
      self.format = :json # bug in AR must be set here
      
      def initialize(attributes = {})
        # json comes in nested {client={data}
        attr = attributes[self.class.element_name] || attributes
        super(attr)
      end

      # Define the connection to be used when talking to a salesking server
      def self.set_connection(opts)
        self.site = opts[:site]        #"http://demo.salesking.local:3000/api/"
        self.user = opts[:user]        # "demo@salesking.eu"
        self.password = opts[:password]   #"demo"
        self.format = opts[:format].to_sym    #:json
      end

    end
  end
end