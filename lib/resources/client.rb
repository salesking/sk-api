module SKApi
  module Resources
    class Client < SKApi::Resources::Base

      def save
        save_with_validation
      end

      def self.schema
        { "type" => "object",
        "properties" => SKApi::Resources::Client.schema_props}
      end

      def self.schema_props
       {
           "id"           => {"type" => "string", "identity" => true , "readonly" => true},
           "number"       => {"type" => "string", "optional" => true},
           "organisation" => {"type" => "string"},
           "first_name"   => {"type" => "string", "optional" => true},
           "last_name"    => {"type" => "string", "optional" => true},
           "title"        => {"type" => "string", "optional" => true},
           "position"     => {"type" => "string", "optional" => true},
           "gender"       => {"type" => "string", "enum" => ["male", "female"] , "optional" => true},
           "email"        => {"type" => "string", "optional" => true},
           "birthday"     => {"type" => "string", "format" =>"date", "optional" => true},
           "url"          => {"type" => "string", "optional" => true},
           "phone_fax"    => {"type" => "string", "optional" => true},
           "phone_mobile" => {"type" => "string", "optional" => true},
           "phone_office" => {"type" => "string", "optional" => true},
           "phone_home"   => {"type" => "string", "optional" => true},
           "bank_owner"   => {"type" => "string", "optional" => true},
           "bank_name"    => {"type" => "string", "optional" => true},
           "bank_number"  => {"type" => "string", "optional" => true},
           "bank_account_number" => {"type" => "string", "optional" => true},
           "bank_iban"      => {"type" => "string", "optional" => true},
           "bank_swift"     => {"type" => "string", "optional" => true},
           "vat_number"     => {"type" => "string", "optional" => true},
           "tax_number"     => {"type" => "string", "optional" => true},
           "tag_list"       => {"type" => "string", "optional" => true},
           "cash_discount"  => {"type" => "number", "optional" => true},
           "due_days"       => {"type" => "integer", "optional" => true},
           "payment_method" => {"type" => "string", "enum" => ["draft", "open", "closed"], "optional" => true},
           "sending_method" => {"type" => "string", "enum" => ["draft", "open", "closed"], "optional" => true},
           "lock_version"   => {"type" => "integer", "readonly" => true, "optional" => true},
           "created_at"     => {"type" => "string", "format" =>"date-time", "optional" => true, "readonly" => true},
           "updated_at"     => {"type" => "string", "format" =>"date-time", "optional" => true, "readonly" => true},
           "address_field"  => {"type" => "string", "optional" => true, "readonly" => true},
           "addresses"      => {"type" => "array"},
         }
      end #schema_props

    end #Client
  end #Resources
end #SKApi