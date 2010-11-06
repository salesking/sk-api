# vim: fileencoding=utf-8

module JSON
  class Schema
    VERSION = '2.0.0'
    class ValueError < Exception;end
    class SchemaError < Exception;end
    class Undefined;end
    TypesMap = {
      "string"  => String,
      "integer" => [Integer, Fixnum],
      "number"  => [Integer, Float, Fixnum, Numeric],
      "boolean" => [TrueClass, FalseClass],
      "object"  => Hash,
      "array"   => Array,
      "null"    => NilClass,
      "any"     => nil
    }
    TypesList = [String, Integer, Float, Fixnum, Numeric, TrueClass, FalseClass, Hash, Array, NilClass]
    def initialize interactive
      @interactive = interactive
      @refmap = {}
    end

    def check_property value, schema, key, parent
      return unless schema
      # if id field is present, set refmap to schema
      @refmap[schema['id']] = schema if schema['id']
      # recurse with extended scheme
      check_property(value, schema['extends'], key, parent) if schema['extends']
      #
      if value == Undefined
        # value is NOT optional 
        raise ValueError, "#{key} is missing and it is not optional" unless schema['optional']     
        # a default value ??
        if @interactive && !parent.include?(key) && !schema['default'].nil? && !schema["readonly"]
          parent[key] = schema['default']
        end
      else # At least not undefined
        # type given, validates if value is of given type(Hash, Array, String, ...)
        # if val ist NOT NIL and required
        check_type(value, schema['type'], key, parent) if schema['type'] #&& !value.nil? && !schema['optional']

        # disallowed value type given
        if schema['disallow']
          flag = true
          begin
            check_type(value, schema['disallow'], key, parent)
          rescue ValueError
            flag = false
          end
          raise ValueError, "disallowed value was matched" if flag
        end
        # dont go further for nil values
        return if value.nil?
        if value.instance_of? Array
          if schema['items']
            if schema['items'].instance_of?(Array)
              schema['items'].each_with_index {|val, index|
                check_property(undefined_check(value, index), schema['items'][index], index, value)
              }
              if schema.include?('additionalProperties')
                additional = schema['additionalProperties']
                if additional.instance_of?(FalseClass)
                  if schema['items'].size < value.size
                    raise ValueError, "There are more values in the array than are allowed by the items and additionalProperties restrictions."
                  end
                else
                  value.each_with_index {|val, index|
                    check_property(undefined_check(value, index), schema['additionalProperties'], index, value)
                  }
                end
              end
            else
              value.each_with_index {|val, index|
                check_property(undefined_check(value, index), schema['items'], index, value)
              }
            end
          end
          if schema['minItems'] && value.size < schema['minItems']
            raise ValueError, "There must be a minimum of #{schema['minItems']} in the array"
          end
          if schema['maxItems'] && value.size > schema['maxItems']
            raise ValueError, "There must be a maximum of #{schema['maxItems']} in the array"
          end
        elsif schema['properties']
          check_object(value, schema['properties'], schema['additionalProperties'])
        elsif schema.include?('additionalProperties')
          additional = schema['additionalProperties']
          unless additional.instance_of?(TrueClass)
            if additional.instance_of?(Hash) || additional.instance_of?(FalseClass)
              properties = {}
              value.each {|k, val|
                if additional.instance_of?(FalseClass)
                  raise ValueError, "Additional properties not defined by 'properties' are not allowed in field '#{k}'"
                else
                  check_property(val, schema['additionalProperties'], k, value)
                end
              }
            else
              raise ValueError, "additionalProperties schema definition for field '#{}' is not an object"
            end
          end
        end

        if value.instance_of?(String)
          # pattern
          if schema['pattern'] && !(value =~ Regexp.new(schema['pattern']))
            raise ValueError, "does not match the regex pattern #{schema['pattern']}"
          end

          strlen = value.split(//).size
          # maxLength
          if schema['maxLength'] && strlen > schema['maxLength']
            raise ValueError, "may only be #{schema['maxLength']} characters long"
          end

          # minLength
          if schema['minLength'] && strlen < schema['minLength']
            raise ValueError, "must be at least #{schema['minLength']} characters long"
          end
        end

        if value.kind_of?(Numeric)

          # minimum + minimumCanEqual
          if schema['minimum']
            minimumCanEqual = schema.fetch('minimumCanEqual', Undefined)
            if minimumCanEqual == Undefined || minimumCanEqual
              if value < schema['minimum']
                raise ValueError, "must have a minimum value of #{schema['minimum']}"
              end
            else
              if value <= schema['minimum']
                raise ValueError, "must have a minimum value of #{schema['minimum']}"
              end
            end
          end

          # maximum + maximumCanEqual
          if schema['maximum']
            maximumCanEqual = schema.fetch('maximumCanEqual', Undefined)
            if maximumCanEqual == Undefined || maximumCanEqual
              if value > schema['maximum']
                raise ValueError, "must have a maximum value of #{schema['maximum']}"
              end
            else
              if value >= schema['maximum']
                raise ValueError, "must have a maximum value of #{schema['maximum']}"
              end
            end
          end

          # maxDecimal
          if schema['maxDecimal'] && schema['maxDecimal'].kind_of?(Numeric)
            if value.to_s =~ /\.\d{#{schema['maxDecimal']+1},}/
              raise ValueError, "may only have #{schema['maxDecimal']} digits of decimal places"
            end
          end

        end

        # enum
        if schema['enum']
          unless(schema['enum'].detect{|enum| enum == value })
            raise ValueError, "does not have a value in the enumeration #{schema['enum'].join(", ")}"
          end
        end

        # description
        if schema['description'] && !schema['description'].instance_of?(String)
          raise ValueError, "The description for field '#{value}' must be a string"
        end

        # title
        if schema['title'] && !schema['title'].instance_of?(String)
          raise ValueError, "The title for field '#{value}' must be a string"
        end

        # format
        if schema['format']
        end

      end
    end

    def check_object value, object_type_def, additional
      if object_type_def.instance_of? Hash
        if !value.instance_of?(Hash) || value.instance_of?(Array)
          raise ValueError, "an object is required"
        end

        object_type_def.each {|key, odef|
          if key.index('__') != 0
            check_property(undefined_check(value, key), odef, key, value)
          end
        }
      end
      value.each {|key, val|
        if key.index('__') != 0 && object_type_def && !object_type_def[key] && additional == false
          raise ValueError, "#{value.class} The property #{key} is not defined in the schema and the schema does not allow additional properties"
        end
        requires = object_type_def && object_type_def[key] && object_type_def[key]['requires']
        if requires && !value.include?(requires)
          raise ValueError, "the presence of the property #{key} requires that #{requires} also be present"
        end
        if object_type_def && object_type_def.instance_of?(Hash) && !object_type_def.include?(key)
          check_property(val, additional, key, value)
        end
        if !@interactive && val && val['$schema']
          check_property(val, val['$schema'], key, value)
        end
      }
    end

    # Checks the type of a given value
    # === Parameter
    # value<>
    # type<>
    # key<>
    # parent<>
    def check_type value, type, key, parent
      converted_fieldtype = convert_type(type)
      if converted_fieldtype
        if converted_fieldtype.instance_of? Array
          datavalid = false
          converted_fieldtype.each do |t|
            begin
              check_type(value, t, key, parent)
              datavalid = true
              break
            rescue ValueError
              next
            end
          end
          unless datavalid
            raise ValueError, "#{value.class} value found, but a #{type} is required"
          end
        elsif converted_fieldtype.instance_of? Hash
          check_property(value, type, key, parent)
        else
          unless value.instance_of? converted_fieldtype
            raise ValueError, "#{value.class} value found, but a #{type} is required"
          end
        end
      end
    end

    def undefined_check value, key
      value.fetch(key, Undefined)
    end

    def convert_type fieldtype
      if TypesList.include?(fieldtype) || fieldtype.kind_of?(Hash)
        return fieldtype
      elsif fieldtype.kind_of? Array
        converted_fields = []
        fieldtype.each do |subfieldtype|
          converted_fields << convert_type(subfieldtype)
        end
        return converted_fields
      elsif !fieldtype
        return nil
      else
        fieldtype = fieldtype.to_s
        if TypesMap.include?(fieldtype)
          return TypesMap[fieldtype]
        else
          raise ValueError, "Field type '#{fieldtype}' is not supported."
        end
      end
    end

    # Validates an instance against a given schema
    # === Parameter
    # instance<Hash{String=>Mixed}:: The instanciated record as hash with fields
    # as keys and values of the to be checked types=> Int, String, Bool, Nil...
    #   {'name'=>'Chubby', :total=>1.234, :=>}
    # instance<Hash{String=>String, Hash}:: the schema used to validate the instance
    # {'properties'=>{}}
    def validate instance, schema
      schema ||= instance['$schema'] # self defined schema
      check_property(instance, schema, 'self', @tree)
      return instance
    end

    def self.validate data, schema=nil, interactive=true
      validator = JSON::Schema.new(interactive)
      validator.validate(data, schema)
    end
end
end