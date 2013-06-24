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

  module Object
    module Connection
      def self.prologue

        XMLRPC::Client.stub(:new).with(Openerp.host, Openerp.object, Openerp.port)
        .and_return().stub(:proxy).with(nil,'dbname',2,'pwd').and_return()
      end
    end

    module Search
      def self.prologue
        Connection.prologue.stub(:execute)
        .with('receiver_model','search', [['field', 'operator', 'value' ]])
      end

      def self.successful
          self.prologue.and_return([1,2])
      end

    end

    module Read
      def self.prologue
        Connection.prologue.stub(:execute)
        .with('receiver_model','read',[1,2],['fields'])
      end

      def self.standard_response
        [{id:1,name:'un'},{id:2,name:'two'}]
      end

      def self.successful
        self.prologue.and_return(self.standard_response)
      end
    end

  end

end
