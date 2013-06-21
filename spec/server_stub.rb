module ServerStub
  module Common
    module Login

      ##
      # Common to all login stubs
      #

      def self.prologue
        XMLRPC::Client::Proxy.any_instance
        .stub(:login).with('dbname', 'user','password')
      end

      ##
      # faultCode for wrong database name
      #
      def self.wrong_database_name_fault_code
        %q(FATAL:  database "dbname" does not exist)
      end

      ##
      # Simulate wrong database name response
      #
      def self.wrong_data_base_name
        self.prologue
        .and_raise(XMLRPC::FaultException.new(self.wrong_database_name_fault_code, 'bla'))
      end

      def self.wrong_user_name
        self.prologue.and_return(false)
      end

      def self.uid
        2
      end

      def self.successful
        self.prologue.and_return(self.uid)
      end
    end

  end
end
