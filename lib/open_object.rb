require 'xmlrpc/client'
require 'xmlrpc/parser_patch'


module OpenObject

  def self.define_setter(attr)
    class_eval("def self.#{attr}=(val) \n @@#{attr} = val \n end \n", __FILE__, __LINE__+1)
  end

  def self.define_getter(attr)
    class_eval("def self.#{attr} \n @@#{attr} \n end \n", __FILE__, __LINE__+1)
  end


  [:host, :port, :common, :object, :base].each do |attr|
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
      BackendResponse.new(success: false, errors: [error.faultCode])
    end
  end

  def self.common_client
    XMLRPC::Client.new(@@host, @@common, @@port).proxy(nil)
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
      begin
        result = connection(user_context).execute(open_object_model, 'search', args)
        BackendResponse.new(success: true, errors: nil, content: result, base_model_class: self)
      rescue RuntimeError => e
        BackendResponse.new(success: false, errors: e.message, content: nil)
      end
    end

    def create(user_context, args = [])
      begin
        id = connection(user_context).execute(open_object_model, 'create', args)
        BackendResponse.new(success: true, errors: nil, content: id)
      rescue RuntimeError => e
        Rails.logger.error(e.message)
        BackendResponse.new(success: false, errors: e.message)
      end
    end

    def read(user_context, ids, fields = [])
      begin
        result = connection(user_context).execute(open_object_model, 'read', ids, fields)
        BackendResponse.new(success: true, errors: nil, content: result)
      rescue => e
        BackendResponse.new(success: false, errors: e)
      end
    end

    def write(user_context, ids, args)
      begin
        res = connection(user_context).execute(open_object_model, 'write', ids, args)
        BackendResponse.new( success: res, errors: nil)
      rescue RuntimeError => e
        Rails.logger.error(e.message.inspect)
        BackendResponse.new(success: false, errors: e.message)
      end
    end

  end

end