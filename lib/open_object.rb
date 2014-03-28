##
#
# Bintje Maps OpenERP xml object to Ruby objects
#
#    Copyright (C) 2013  Siclic
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU Affero General Public License as
#    published by the Free Software Foundation, either version 3 of the
#    License, or (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU Affero General Public License for more details.
#
#    You should have received a copy of the GNU Affero General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
##

# XMLRPC client is a ruby standard library
require 'xmlrpc/client'

# XMLRPC parser patch
require 'xmlrpc/parser_patch'


module OpenObject

  # Defines a setter for the `attr` class variable within the current class
  # @param attr [Symbol] the class variable name
  def self.define_setter(attr)
    class_eval("def self.#{attr}=(val) \n @@#{attr} = val \n end \n", __FILE__, __LINE__+1)
  end

  # Defines a getter method for the given class variable
  # ( see #define_setter)
  # @note This is the getter version
  def self.define_getter(attr)
    class_eval("def self.#{attr} \n @@#{attr} \n end \n", __FILE__, __LINE__+1)
  end


  [:host, :port, :common, :object, :base, :logger].each do |attr|
    define_setter(attr)
    define_getter(attr)
  end


  # Authenticate againts OpenObject
  # @param dbname [String] the open object database name
  # @param user [String] the OpenObject user name
  # @param password [String] the OpenObject password
  # @return [BackendResponse] either failure or the OpenObject user id
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

  # Shorcut to the OpenObject's common service
  def self.common_client
    XMLRPC::Client.new(@@host, @@common, @@port).proxy(nil)
  end

  # Take a code block and rescue XMLRPC::FaultException
  # Place the exception details in `BackendResponse` errors hash
  # @yield The given code block should be an xmlrpc operation
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

    # Build a new `BackendResponse` object to carry the OpenObject response in a standard structure
    #
    # @param success [Boolean] `true` if the operation succeed 
    # @param errors [Hash] the errors object with `faultCode` and `faultString` keys
    # @param content [String, Hash, Array] any valid xmlrpc response 
    # @param base_model_class [String] model class string name
    # @return [BackendResponse]
    def initialize(success: false, errors: [], content: nil, base_model_class: nil)
      @success = success
      @errors = errors
      @content = content
    end

    attr_accessor :success, :errors, :content

  end


  # When included in a class, extend receiving class with ClassMethods module methods
  # 
  # @param base [Class] receiving class
  #
  def self.included(base)
    # Extends receiving class (base) with ClassMethods
    base.extend(ClassMethods)
  end


  # extended class methods
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

    # Builds OpenObject connection
    # @param user_context [Hash] the hash MUST contain keys and values for `dbname`, `uid`, `password` 
    # @return [XMLRPC::Client::Proxy]
    def connection(user_context)
      XMLRPC::Client.new(OpenObject.host, OpenObject.object, OpenObject.port)
      .proxy(nil, user_context[:dbname], user_context[:uid], user_context[:pwd])
    end

    # OpenObject search query
    # @param use_context (see #connection)
    # @param args [Array] the OpenObject method's args see OpenObject's documentation
    # @param offset [Fixnum] see OpenObject's documentation
    # @param limit [Fixnum] see OpenObject's documentation
    # @param order [String] see OpenObject's documentation
    # @return [BackendResponse] see OpenObject's documentation
    def search(user_context, args = [], offset: 0, limit: 0, order: nil)
      open_object_request_parameters = [offset, limit, order].compact
      OpenObject.rescue_xmlrpc_fault do
        result = connection(user_context).execute(open_object_model, 'search', args, *open_object_request_parameters )
        OpenObject.logger.debug("OpenObject.search with #{args}")
        OpenObject.logger.debug("Responded with : #{result}")
        BackendResponse.new(success: true, errors: nil, content: result)
      end
    end

    # OpenObject's create
    # (see #search)
    def create(user_context, args = [])
      OpenObject.rescue_xmlrpc_fault do
        result = connection(user_context).execute(open_object_model, 'create', args)
        OpenObject.logger.debug("OpenObject.create with #{args}")
        OpenObject.logger.debug("Responded with : #{result}")
        BackendResponse.new(success: true, errors: nil, content: result)
      end
    end

    # OpenObject's read
    # (see #search)
    # @param ids [Array<Fixnum>] the OpenObject's ids
    # @param fields [Array<String>]    see OpenObject's documentation
    def read(user_context, ids, fields = [])
      OpenObject.rescue_xmlrpc_fault do
        result = connection(user_context).execute(open_object_model, 'read', ids, fields)
        OpenObject.logger.debug("OpenObject.read ids : #{ids} fields :  #{fields}")
        OpenObject.logger.debug("Responded with : #{result}")
        BackendResponse.new(success: true, errors: nil, content: result)
      end
    end

    # OpenObject's write
    # (see #read )
    # (see #create )
    def write(user_context, ids, args)
      OpenObject.rescue_xmlrpc_fault do
        result = connection(user_context).execute(open_object_model, 'write', ids, args)
        OpenObject.logger.debug("OpenObject.write ids : #{ids} args :  #{args}")
        OpenObject.logger.debug("Responded with : #{result}")
        BackendResponse.new( success: result, errors: nil)
      end
    end

    # OpenObject's unlink
    # ( see #read )
    def unlink(user_context,ids)
      OpenObject.rescue_xmlrpc_fault do
        result = connection(user_context).execute(open_object_model, 'unlink', ids)
        OpenObject.logger.debug("OpenObject.unlink ids : #{ids}")
        OpenObject.logger.debug("Responded with : #{result}")
        BackendResponse.new( success: result, errors: nil)
      end
    end

  end

end
