module ServerStub

  # Load fake faultCode
  def self.faultCode
    File.read('spec/data/faultCode.txt')
  end

  # Load fake faultString
  def self.faultString
    File.read('spec/data/faultString.txt')
  end

  module Common
    module Login

      # Common to all login stubs
      def self.prologue
        XMLRPC::Client::Proxy.any_instance
        .stub(:login).with('dbname', 'user','password')
      end

      # faultCode for wrong database name
      def self.wrong_database_name_fault_code
        %q(FATAL:  database "dbname" does not exist)
      end

      
      # Fake UID for success
      def self.uid
        2
      end


      # Simulate wrong database name response
      def self.wrong_data_base_name
        self.prologue
        .and_raise(XMLRPC::FaultException.new(self.wrong_database_name_fault_code, 'bla'))
      end

      # Simulate wrong user name
      def self.wrong_user_name
        self.prologue.and_return(false)
      end


      # Simulate success
      def self.successful
        self.prologue.and_return(self.uid)
      end
    end

  end

  module Object

    # Embed connection stubbing reused in specific modules
    module Connection
      def self.prologue
        XMLRPC::Client.stub(:new).with(OpenObject.host, OpenObject.object, OpenObject.port)
        .and_return().stub(:proxy).with(nil,'dbname',2,'pwd').and_return()
      end
    end

    module Search
      # Initialise stub request with default args
      def self.prologue
        Connection.prologue.stub(:execute)
        .with('receiver_model','search', [['field', 'operator', 'value' ]],0,0)
      end
      
      # Stub success result
      def self.successful
          self.prologue.and_return([1,2])
      end

      # Stub failure result
      def self.failure
        self.prologue.and_raise(XMLRPC::FaultException.new(ServerStub.faultCode, ServerStub.faultString))
      end

    end

    module Read
      # Initialise stub request with default args
      def self.prologue
        Connection.prologue.stub(:execute)
        .with('receiver_model','read',[1,2],['fields'])
      end
      
      # Standard response shortcut
      def self.standard_response
        [{id:1,name:'un'},{id:2,name:'two'}]
      end

      # Stub success result
      def self.successful
        self.prologue.and_return(self.standard_response)
      end

      # Stub failure result
      def self.failure
        self.prologue.and_raise(XMLRPC::FaultException.new(ServerStub.faultCode, ServerStub.faultString))
      end
    end

    module Write
      # Initialise stub request with default args
      def self.prologue
        Connection.prologue.stub(:execute)
        .with('receiver_model','write',[1,2],{field:'value'})
      end

      # Standard response shortcut
      def self.standard_response
        true
      end

      # Stub success result
      def self.successful
        self.prologue.and_return(self.standard_response)
      end

      # Stub failure result
      def self.failure
        self.prologue.and_raise(XMLRPC::FaultException.new(ServerStub.faultCode, ServerStub.faultString))
      end
    end

    module Create
      # Initialise stub request with default args
      def self.prologue
        Connection.prologue.stub(:execute)
        .with('receiver_model','create',{field:'value'})
      end

      # Standard response shortcut
      def self.standard_response
        1
      end

      # Stub success result
      def self.successful
        self.prologue.and_return(self.standard_response)
      end

      # Stub failure result
      def self.failure
        self.prologue.and_raise(XMLRPC::FaultException.new(ServerStub.faultCode, ServerStub.faultString))
      end
    end


  end

end
