require 'spec_helper'

describe 'reciever model' do
  before(:each) do
    openerp_settings
  end
  let(:user_context) { {dbname: 'dbname', uid: 2, pwd: 'pwd'} }

  class ReceiverModel
    include Openerp
  end

  it 'should respond to .openerp_model' do
    ReceiverModel.should respond_to(:openerp_model)
  end


  describe '.openerp_model_name' do
    context 'when not defined in model' do

      it 'should be a string' do
        ReceiverModel.openerp_model.class.should be String
      end

      it 'should be humanized model name' do
        ReceiverModel.openerp_model.should eql 'receiver_model'
      end

    end

    describe ".set_openerp_mode('another_name')" do
      class AnotherModel
        include Openerp
      end
      it "should set the openerp model name with the given string" do
        AnotherModel.set_openerp_model "another_name"
        AnotherModel.openerp_model.should eql "another_name"
      end

    end

  end

  describe ".connection(user_context:{dbname:String,uid:Fixnum,pwd:String})" do


    it "should build a new XMLRPC connection" do
      allow_message_expectations_on_nil
      XMLRPC::Client.should_receive(:new)
      .with(Openerp.host, Openerp.object, Openerp.port)
      .and_return().should_receive(:proxy)
      ReceiverModel.connection(user_context)
    end


  end

  describe ".search(user_context, args = [])" do
    before(:each) do
      allow_message_expectations_on_nil
      ServerStub::Object::Search.prologue
    end

    it "creates connection with context" do
      ReceiverModel.should_receive(:connection).with(user_context)
      ReceiverModel.search(user_context, [["field", "operator", "value"]])
    end

    it "invokes execute with search, model_name, params" do
      ServerStub::Object::Connection.prologue.should_receive(:execute)
      .with('receiver_model','search',[["field", "operator", "value"]])
      ReceiverModel.search(user_context, [["field", "operator", "value"]])
    end

    context "successful request" do
      before(:each) { ServerStub::Object::Search.successful }
      let(:response) { ReceiverModel.search(user_context, [["field", "operator", "value"]]) }

      it_behaves_like "any successful request"

      it "response.content should be an Array" do
        response.content.should be_an Array
      end

    end

  end


end