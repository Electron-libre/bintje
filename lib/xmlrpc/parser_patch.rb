module XMLRPC
  module Convert
    # Converts the given +hash+ to an XMLRPC::FaultException object by passing
    # the +faultCode+ and +faultString+ attributes of the Hash to
    # XMLRPC::FaultException.new
    #
    # Raises an Exception if the given +hash+ doesn't meet the requirements.
    # Those requirements being:
    # * 2 keys
    # * <code>'faultCode'</code> key is an Integer
    # * <code>'faultString'</code> key is a String
    def self.fault(hash)
      if hash.kind_of? Hash and hash.size == 2 and
          hash.has_key? "faultCode" and hash.has_key? "faultString" and
          hash["faultCode"].kind_of? Integer or hash["faultCode"].kind_of? String and hash["faultString"].kind_of? String

        XMLRPC::FaultException.new(hash["faultCode"], hash["faultString"])
      else
        raise "wrong fault-structure: #{hash.inspect}"
      end
    end

  end
end
