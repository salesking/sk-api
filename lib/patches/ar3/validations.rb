module ActiveResource

#  module Validations
#    # Validate a resource and save (POST) it to the remote web service.
#    def save_with_validation
#      save_without_validation
#      true
#    rescue ResourceInvalid => error
#      case error.response['Content-Type']
#      when /xml/ #PATCH
#        errors.from_xml(error.response.body)
#      when /json/ #PATCH
#        errors.from_json(error.response.body)
#      end
#      false
#    end
#  end

  class Errors < ActiveModel::Errors

    # Patched cause we dont need no attribute name magic .. and its just simpler
    # orig version is looking up the humanized name of the attribute in the error
    # message, which we dont have only field name is used
    def from_array(messages, save_cache=false)
      clear unless save_cache
      messages.each do |msg|
        add msg[0], msg[1]
      end
    end
  end #Errors

end
