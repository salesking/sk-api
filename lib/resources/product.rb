module SKApi
  module Resources
    class Product < SKApi::Resources::Base

      def save
        save_with_validation
      end

      def self.schema
        { "type" => "object",
        "properties" => SKApi::Resources::Product.schema_props}
      end

      def self.schema_props
        {
           "id"           => {"type" => "string", "identity" => true , "readonly" => true},
           "number"       => {"type" => "string", "optional" => true},
           "name"         => {"type" => "string"},
           "description"  => {"type" => "string", "optional" => true},
           "price"        => {"type" => "number"},
           "tax"          => {"type" => "number", "optional" => true},
           "quantity_unit"=> {"type" => "string", "optional" => true},
           "tag_list"     => {"type" => "string", "optional" => true},
           "lock_version" => {"type" => "integer", "readonly" => true, "optional" => true},
           "published_at" => {"type" => "string", "format" =>"date", "optional" => true},
           "created_at"   => {"type" => "string", "format" =>"date-time", "optional" => true, "readonly" => true},
           "updated_at"   => {"type" => "string", "format" =>"date-time", "optional" => true, "readonly" => true},
         }
      end #schema_props

    end #Product
  end #Resources
end #SKApi