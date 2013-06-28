require 'xmlrpc/client'
require 'xmlrpc/parser_patch'


module OpenObject

  def self.define_setter(attr)
    class_eval("def self.#{attr}=(val) \n @@#{attr} = val \n end \n", __FILE__, __LINE__+1)
  end

  def self.define_getter(attr)
    class_eval("def self.#{attr} \n @@#{attr} \n end \n", __FILE__, __LINE__+1)
  end


  [:host, :port, :common, :object, :base, :logger].each do |attr|
    define_setter(attr)
    define_getter(attr)
  end


  def self.login(dbname, user, password)
    begin
      if uid = common_client.login(dbname, user, password)
        BackendResponse.new(success: true, content: uid)
      else
        BackendResponse.new(success: false, errors: ['Authentication failed'])
      end
    rescue XMLRPC::FaultException => error
      BackendResponse.new(success: false, errors: {faultCode: error.faultCode, faultString: error.faultString})
    end
  end

  def self.common_client
    XMLRPC::Client.new(@@host, @@common, @@port).proxy(nil)
  end

  # Take a code block and rescue XMLRPC::FaultException
  # Place the exception details in errors hash
  def self.rescue_xmlrpc_fault(&block)
    begin
      yield block
    rescue XMLRPC::FaultException => error
      OpenObject.logger.error("Rescued from XMLRPC::FaultException : \n #{error.inspect}")
      BackendResponse.new(success: false, errors: {faultCode: error.faultCode, faultString: error.faultString})
    end
  end

  ##
  # Encapsultation of open_object responses
  #
  class BackendResponse

    def initialize(success: false, errors: [], content: nil, base_model_class: nil)
      @success = success
      @errors = errors
      @content = content
    end

    attr_accessor :success, :errors, :content

  end


  # Current module methods
  def self.included(base)
    # Extends receiving class (base) with ClassMethods
    base.extend(ClassMethods)
  end

  # TODO : is there any way / point in creation of connection object instance ? Connection.new(user_context) ...

  ## extended class methods
  module ClassMethods

    ##
    # To set model name in case it is not the humanized class name
    # @param model : String
    #
    def set_open_object_model(model = String.new)
      @open_object_model = model
    end

    ##
    # @return String : value of the open_object model
    #
    def open_object_model
      @open_object_model ||= self.name.underscore
    end


    def connection(user_context)
      XMLRPC::Client.new(OpenObject.host, OpenObject.object, OpenObject.port)
      .proxy(nil, user_context[:dbname], user_context[:uid], user_context[:pwd])
    end


    def search(user_context, args = [])
      OpenObject.rescue_xmlrpc_fault do
        result = connection(user_context).execute(open_object_model, 'search', args)
        OpenObject.logger.debug("OpenObject.search with #{args}")
        OpenObject.logger.debug("Responded with : #{result}")
        BackendResponse.new(success: true, errors: nil, content: result)
      end
    end

    def create(user_context, args = [])
      OpenObject.rescue_xmlrpc_fault do
        result = connection(user_context).execute(open_object_model, 'create', args)
        OpenObject.logger.debug("OpenObject.create with #{args}")
        OpenObject.logger.debug("Responded with : #{result}")
        BackendResponse.new(success: true, errors: nil, content: result)
      end
    end

    def read(user_context, ids, fields = [])
      OpenObject.rescue_xmlrpc_fault do
        result = connection(user_context).execute(open_object_model, 'read', ids, fields)
        OpenObject.logger.debug("OpenObject.read ids : #{ids} fields :  #{fields}")
        OpenObject.logger.debug("Responded with : #{result}")
        BackendResponse.new(success: true, errors: nil, content: result)
      end
    end

    def write(user_context, ids, args)
      OpenObject.rescue_xmlrpc_fault do
        result = connection(user_context).execute(open_object_model, 'write', ids, args)
        OpenObject.logger.debug("OpenObject.write ids : #{ids} args :  #{args}")
        OpenObject.logger.debug("Responded with : #{result}")
        BackendResponse.new( success: result, errors: nil)
      end
    end

  end

end