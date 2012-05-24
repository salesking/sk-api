#require 'rubygems'
require 'active_resource'
require 'active_resource/version'
# patches are for specific AR version
# switch A-resource patch includes

if ActiveResource::VERSION::MAJOR == 3
  require 'patches/ar3/base'
  require 'patches/ar3/validations'
elsif ActiveResource::VERSION::MAJOR < 3
  require 'patches/ar2/validations'
  require 'patches/ar2/base'
end

# utilities
require 'utils/field_map'
require 'utils/serializer'

#resources
require 'resources/base'
require 'resources/product'
require 'resources/client'
require 'resources/address'
require 'resources/invoice'
require 'resources/credit_note'
require 'resources/line_item'