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
    let(:response) { ReceiverModel.search(user_context, [["field", "operator", "value"]]) }

    it_behaves_like "any object request"

    it "invokes execute with model_name, search, [params]" do
      ServerStub::Object::Connection.prologue.should_receive(:execute)
      .with('receiver_model','search',[["field", "operator", "value"]])
      response
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

  describe ".read(user_context,[ids],[fields])" do
    before(:each) do
      allow_message_expectations_on_nil
      ServerStub::Object::Read.prologue
    end

    let(:response) {ReceiverModel.read(user_context,[1,2],['fields']) }

    it_behaves_like "any object request"

    it "invokes execute with model_name, read, [ids], [fields]" do
      ServerStub::Object::Connection.prologue.should_receive(:execute)
      .with('receiver_model','read',[1,2],['fields'])
      response
    end

    context "successful request" do
      before(:each) do
        ServerStub::Object::Read.successful
      end

      it_behaves_like "any successful request"

      it "response.content should be Array" do
        response.content.should be_an Array
      end

      it "reponse.content.first should be #{ServerStub::Object::Read.standard_response.first}" do
        response.content.first.should eql ServerStub::Object::Read.standard_response.first
      end

    end

  end

  describe ".write(user_context,[ids],{field:'value'})" do
    before(:each) do
      allow_message_expectations_on_nil
      ServerStub::Object::Write.prologue
    end
    let(:response) { ReceiverModel.write(user_context, [1,2],{field:'value'})}

    it_behaves_like "any object request"

    it "invokes execute with model_name, 'write', [ids], {field:'value'}" do
      ServerStub::Object::Connection.prologue.should_receive(:execute)
      .with('receiver_model', 'write', [1,2], {field:'value'})
      response
    end

    context "successful request" do
      before(:each) do
        ServerStub::Object::Write.successful
      end

      it_behaves_like "any successful request"

      it "response.content should be nil" do
        response.content.should be nil
      end

    end

  end

end