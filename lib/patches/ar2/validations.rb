module ActiveResource

  module Validations
    # Validate a resource and save (POST) it to the remote web service.
    def save_with_validation
      save_without_validation
      true
    rescue ResourceInvalid => error
      case error.response['Content-Type']
      when /xml/ #PATCH
        errors.from_xml(error.response.body)
      when /json/ #PATCH
        errors.from_json(error.response.body)
      end
      false
    end
  end

  class Errors

    # Patched cause we dont need no attribute name magic .. and its just simpler
    def from_array(messages)
      clear
      messages.each do |msg|
        add msg[0], msg[1]
      end
    end
  end #Errors

end
