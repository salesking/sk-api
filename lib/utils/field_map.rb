module SKApi
  module Utils
    # Provide methods for mapping the fields of a remote object to local object
    # The class holds two objects (f.ex. a remote and a local object) and works 
    # with a hash which maps the fields between those two.
    # If you use such a mapping both of your objects MUST respond to the method
    # names passed in the mapping-table(hash)
    # ==== Example
    #
    #  contact_map = {
    #     :loc_key => :name,
    #     :rem_key => :firstname,
    #     :obj => 'Stanza::SalesKing::Mapping::ContactTrans',
    #     :loc_trans=>:set_local_name,
    #     :rem_trans=> :set_remote_name
    #   }
    #   map = SKApi::Utils::FieldMap.new(@local_user, @remote_user, contact_map)
    #   map.update_remote #Does not save! only sets the field values on the remote object
    #   
    # ==== Mapping Hash Explanation
    #   
    #  {
    #    :loc_key => :name,               => Local fieldname    #
    #    :rem_key => :firstname,          => remote fieldname
    #    :obj => 'ATransitionClass',      => The class which hold the following Transition methods as Class.methods
    #    :loc_trans=>:set_local_name,     =>  Method called when local field is updated
    #    :rem_trans=> :set_remote_name    =>  Method called when remote field is update
    #  }
    class FieldMap

      # The local object
      attr_accessor :loc_obj
      # The remote object
      attr_accessor :rem_obj
      # <Hash{Symbol=>Symbol, Symbol=>{Hash} }>::the field mapping
      attr_accessor :fields
      # the outdated fields
      attr_reader :outdated
      # <Array[String]>::log field changes
      attr_reader :log

      # Takes a local and remote object which should respond to function defined
      # in the mapping hash
      def initialize(loc_obj, rem_obj, fields)
        @loc_obj = loc_obj
        @rem_obj = rem_obj
        @fields = fields
        @log = []
      end

      # check if the any of the fields are outdated
      # populates self.outdated array with outdated fields
      # ==== Returns
      # <Boolean>:: false if not outdated
      def outdated?
        @outdated = []
        fields.each do |fld|
          if fld[:trans]
            # SomeTransferObject.remote_tranfer_function(remote_obj_data)
            virtual_local_val  = fld[:trans][:obj].constantize.send( fld[:trans][:rem_trans], loc_obj.send( fld[:loc_key] ) )
            @outdated << fld if virtual_local_val != rem_obj.send( fld[:rem_key] )
          else
            @outdated << fld if rem_obj.send( fld[:rem_key] ) != loc_obj.send( fld[:loc_key] )
          end          
        end
        !@outdated.empty?
      end

      # update all local outdated fields wit hvcalues from remote object
      def update_local_outdated
        update_local(@outdated) if outdated?
      end
      # update all remote outdated fields wit hvalues from local object
      def update_remote_outdated
        update_remote(@outdated) if outdated?
      end

      # update all local fields with values from remote
      def update_local(field=nil)
        flds = field ? ( field.is_a?(Array) ? field : [field] ) : fields
        flds.each do |fld|
          old_val = loc_obj.send(fld[:loc_key]) rescue 'empty'
          new_val = if fld[:trans] #call transfer function
                      fld[:trans][:obj].constantize.send( fld[:trans][:loc_trans], rem_object.send( fld[:rem_key] ) )
                    else # lookup directly on local object
                      rem_obj.send(fld[:rem_key])
                    end
          loc_obj.send( "#{fld[:loc_key]}=", new_val )
          # write to log
          log << "local: #{fld[:loc_key]} was: #{old_val} updated from remote: #{fld[:rem_key]} with value: #{new_val}"
        end
      end

      # Update all or given remote fields with the value of the local fields
      # 
      def update_remote(field=nil)
        flds = field ? ( field.is_a?(Array) ? field : [field] ) : fields
        flds.each do |fld|
          old_val = rem_obj.send(fld[:rem_key]) rescue 'empty'# rember for log
          new_val = if fld[:trans] #call transfer function
                      fld[:trans][:obj].constantize.send( fld[:trans][:rem_trans], loc_obj.send( fld[:loc_key] ) )
                    else # lookup directly on local object
                      loc_obj.send( fld[:loc_key] )
                    end
          rem_obj.send( "#{fld[:rem_key]}=" , new_val )
          log << "remote: #{fld[:rem_key]} was: #{old_val} updated from local: #{fld[:loc_key]} with value: #{new_val}"
        end
      end

    end # FieldMapping
  end # Utils
end #SKApi