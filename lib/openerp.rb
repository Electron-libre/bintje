require 'xmlrpc/client'

module Openerp

  mattr_reader :host, :port, :common, :object, :base

  def self.login(dbname, user, password)
    common_client.login(dbname, user, password)
  end

  def self.common_client
    XMLRPC::Client.new(@@host, @@common, @@port).proxy(nil)
  end

  ##
  # Encapsultation of openerp responses
  #
  class BackendResponse

    def initialize(success: false, errors: [], content: nil, base_model_class: nil)
      @success = success
      @errors = errors
      @content = content
      @base_model_class = base_model_class
    end

    attr_accessor :success, :errors, :content

    ##
    # Instantiate object from @base_model_class if it sets and elements responds to keys
    #
    def objectify
      self.content.each do |el|
        if @base_model_class && el.respond_to?(:keys)
          @base_model_class.new(el)
        else
          el
        end
      end

    end
  end


    # Current module methods
    def self.included(base)
      # Extends receiving class (base) with ClassMethods
      base.extend(ClassMethods)
      # Create class method in the receiving class
      base.class_eval do
        include ActiveModel::Model
      end
    end

    # TODO : is there any way / point in creation of connection object instance ? Connection.new(user_context) ...

    ## extended class methods
    module ClassMethods

      ##
      # To set model name in case it is not the humanized class name
      # @param model : String
      #
      def set_openerp_model(model = String.new)
        @@openerp_model = model
      end

      ##
      # @return String : value of the openerp model
      #
      def openerp_model
        @@openerp_model
      end


      def connection(user_context)
        XMLRPC::Client.new(Openerp.host, Openerp.object, Openerp.port).proxy(nil, user_context[:dbname], user_context[:uid], user_context[:pwd])
      end


      def search(user_context, args = [])
        begin
          result = connection(user_context).execute(openerp_model, 'search', args)
          BackendResponse.new(success: true, errors: nil, content: result, base_model_class: self)
        rescue RuntimeError => e
          BackendResponse.new(success: false, errors: e.message, content: nil)
        end
      end

      def create(user_context, args = [])
        begin
          id = connection(user_context).execute(openerp_model, 'create', args)
          {success: true, errors: nil, id: id}
        rescue RuntimeError => e
          Rails.logger.error(e.message)
          {success: false, errors: e.message}
        end
      end

      def read(user_context, ids, fields = [])
        connection(user_context).execute(openerp_model, 'read', ids, fields)
      end

      def write(user_context, ids, args)
        begin
          res = connection(user_context).execute(openerp_model, 'write', ids, args)
          {success: res, errors: nil}
        rescue RuntimeError => e
          Rails.logger.error(e.message.inspect)
          {success: false, errors: e.message}
        end
      end

    end

  end