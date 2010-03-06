# external
require 'active_resource'
unless RUBY_PLATFORM =~ /java/
  require 'yajl'
  require 'rufus-json'

  Rufus::Json.backend = :yajl
else
  require 'json'
  require 'rufus-json'

  Rufus::Json.backend = :json
end

#vendored
require File.dirname(__FILE__) + '/../vendor/jsonschema-1.0.0/lib/jsonschema'

# utilities
require File.dirname(__FILE__) + '/utils/field_map'
require File.dirname(__FILE__) + '/utils/serializer'

#resources
require File.dirname(__FILE__) + '/activeresource_patches/validations'
require File.dirname(__FILE__) + '/activeresource_patches/base'
require File.dirname(__FILE__) + '/resources/base'
require File.dirname(__FILE__) + '/resources/product'
require File.dirname(__FILE__) + '/resources/client'
require File.dirname(__FILE__) + '/resources/address'
require File.dirname(__FILE__) + '/resources/credit_note'
require File.dirname(__FILE__) + '/resources/line_item'