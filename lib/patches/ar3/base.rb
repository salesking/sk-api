module ActiveResource
  # Overridden methods to suit SalesKing.
  # Some changes might be kicked when AR 3.0 is out
  class Base

    # override encode because json is also returned nested by SalesKing
    def encode(options={})
      case self.class.format
        when ActiveResource::Formats[:xml]
          self.class.format.encode(attributes, {:root => self.class.element_name}.merge(options))
        else # json also nested
          self.class.format.encode( {self.class.element_name => attributes}, options)
      end
    end

    # override ARes method to parse only the client part
    def load_attributes_from_response(response)
      if response['Content-Length'] != "0" && response.body.strip.size > 0
        load( self.class.format.decode(response.body)[self.class.element_name] )
      end
    end

    # Overridden to grab the data(= clients-collection) from json:
    # { 'collection'=> will_paginate infos,
    #   'links' => prev/next links
    #   'clients'=> [data], << what we need
    # }
    def self.instantiate_collection(collection, prefix_options = {})
      collection = collection[ self.element_name.pluralize ] if collection.is_a?(Hash)
      collection.collect! { |record| instantiate_record(record, prefix_options) }
    end
  end
end