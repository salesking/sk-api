module SKApi
  module Resources
    class LineItem < SKApi::Resources::Base

      def save
        save_with_validation
      end

      def self.schema
        { "type" => "object",
        "properties" => SKApi::Resources::LineItem.schema_props}
      end

      def self.schema_props
       {
           "id"             => {"type" => "string", "identity" => true , "readonly" => true},
           "position"       => {"type" => "integer"},
           "product_id"     => {"type" => "string", "optional" => true},
           "quantity"       => {"type" => "number"},
           "quantity_unit"  => {"type" => "string", "optional" => true},
           "name"           => {"type" => "string", "optional" => true},
           "description"    => {"type" => "string", "optional" => true},
           "price_single"   => {"type" => "number"},
           "discount"       => {"type" => "number", "optional" => true},
           "tax"            => {"type" => "number", "optional" => true},
           "created_at"     => {"type" => "string", "format" =>"date-time", "optional" => true, "readonly" => true},
           "updated_at"     => {"type" => "string", "format" =>"date-time", "optional" => true, "readonly" => true}
         }
      end
    end
  end
end