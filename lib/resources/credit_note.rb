module SKApi
  module Resources
    class CreditNote < SKApi::Resources::Base

      def save
        save_with_validation
      end

      ##########################################################################
      # Class methods
      ##########################################################################

      def self.schema
        { "type" => "object",
          "properties" => SKApi::Resources::CreditNote.schema_props}
      end

      def self.schema_props
        {
           "id"             => {"type" => "string", "identity" => true, "optional" => true, "readonly" => true},
           "number"         => {"type" => "string", "optional" => true},
           "date"           => {"type" => "string", "format" =>"date", "optional" => true},
           "due_days"       => {"type" => "integer", "optional" => true},
           "title"          => {"type" => "string", "optional" => true},
           "status"         => {"type" => "string", "enum" => ["draft", "open", "closed"], "default" =>"draft", "optional" => true},
           "payment_method" => {"type" => "string", "enum" => ["cash", "bank_transfer", "credit_card", "paypal", "direct_debit", "cheque"], "optional" => true},
           "due_date"       => {"type" => "string", "format" =>"date", "optional" => true},
           "notes_before"   => {"type" => "string", "optional" => true},
           "notes_after"    => {"type" => "string", "optional" => true},
           "price_total"    => {"type" => "number", "optional" => true, "readonly" => true},
           "price_tax"      => {"type" => "number", "optional" => true, "readonly" => true},
           "created_at"     => {"type" => "string", "format" =>"date-time", "optional" => true, "readonly"=> true},
           "updated_at"     => {"type" => "string", "format" =>"date-time", "optional" => true, "readonly"=> true},
           "address_field"  => {"type" => "string", "optional" => true, "readonly" => true},
           "lock_version"   => {"type" => "integer", "optional" => true, "readonly" => true},
           "client_id"      => {"type" => "string"},
           "client"         => {"type" => "object", "properties" => SKApi::Resources::Client.schema_props, "optional" => true, "readonly" => true},
           "line_items"     => {"type" => "array","properties" => SKApi::Resources::LineItem.schema_props, "optional" => true,},
         }
      end

      def self.api_links
        #internal links on fields=> id => salesking.eu/clients/4567.json
      #external links to actions and related objects => invoeis => salesking.eu/clients/4567/invoices.json
        [:edit, :destroy, :copy, :print, :show, :payments, :payment_new]
      end
    end
  end
end