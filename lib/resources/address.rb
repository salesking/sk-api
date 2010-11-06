module SKApi
  module Resources
    class Address < SKApi::Resources::Base

      def save
        save_with_validation
      end    
      
      def self.schema
        { "type" => "object",
        "properties" => SKApi::Resources::Address.schema_props}
      end

      def self.schema_props
        {
           "id"       => {"type" => "string", "identity" => true, "readonly" => true},
           "address1" => {"type" => "string", "optional" => true},
           "address2" => {"type" => "string", "optional" => true},
           "city"     => {"type" => "string"},
           "country"  => {"type" => "string", "optional" => true},
           "state"    => {"type" => "string", "optional" => true},
           "zip"      => {"type" => "string", "optional" => true},
           "pobox"    => {"type" => "string", "optional" => true},
           "long"     => {"type" => "string", "optional" => true},
           "lat"      => {"type" => "string", "optional" => true},
           "address_type" => {"type" => "string", "optional" => true},
           "created_at"   => {"type" => "string", "format" =>"date-time", "readonly"=> true},
           "updated_at"   => {"type" => "string", "format" =>"date-time", "readonly"=> true},

         }
      end

    end
  end
end