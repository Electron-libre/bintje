require 'spec_helper'

describe 'reciever model' do
  before(:each) do
    open_object_settings
  end
  let(:user_context) { {dbname: 'dbname', uid: 2, pwd: 'pwd'} }

  class ReceiverModel
    include OpenObject
  end

  it 'should respond to .open_object_model' do
    ReceiverModel.should respond_to(:open_object_model)
  end


  describe '.open_object_model_name' do
    context 'when not defined in model' do

      it 'should be a string' do
        ReceiverModel.open_object_model.class.should be String
      end

      it 'should be humanized model name' do
        ReceiverModel.open_object_model.should eql 'receiver_model'
      end

    end

    describe ".set_open_object_mode('another_name')" do
      class AnotherModel
        include OpenObject
      end
      it "should set the open_object model name with the given string" do
        AnotherModel.set_open_object_model "another_name"
        AnotherModel.open_object_model.should eql "another_name"
      end

    end

  end

  describe ".connection(user_context:{dbname:String,uid:Fixnum,pwd:String})" do


    it "should build a new XMLRPC connection" do
      allow_message_expectations_on_nil
      XMLRPC::Client.should_receive(:new)
      .with(OpenObject.host, OpenObject.object, OpenObject.port)
      .and_return().should_receive(:proxy)
      ReceiverModel.connection(user_context)
    end


  end

  describe ".search(user_context, args = [], limit:Fixnum, offset:Fixnum)" do
    before(:each) do
      allow_message_expectations_on_nil
      ServerStub::Object::Search.prologue
    end

    let(:response) { ReceiverModel.search(user_context, [["field", "operator", "value"]]) }


    context "with offset and limit parameters" do
      let(:response) { ReceiverModel.search(user_context, [["field", "operator", "value"]],offset: 10,limit: 5) }

      it "invokes execute with model_name, search, [params], offset,limit" do
        ServerStub::Object::Connection.prologue.should_receive(:execute)
        .with('receiver_model','search',[["field", "operator", "value"]], 10 , 5 )
        response
      end

    end

    context "with limit parameter (missing offset)" do
      let(:response) { ReceiverModel.search(user_context, [["field", "operator", "value"]],limit: 5) }

      it "invokes execute with model_name, search, [params], offset :0, limit " do
        ServerStub::Object::Connection.prologue.should_receive(:execute)
        .with('receiver_model','search',[["field", "operator", "value"]], 0 , 5 )
        response
      end

    end

    context "with offset parameter (missing limit)" do
      let(:response) { ReceiverModel.search(user_context, [["field", "operator", "value"]], offset: 10) }

      it "invokes execute with model_name, search, [params], offset, limit: 0" do
        ServerStub::Object::Connection.prologue.should_receive(:execute)
        .with('receiver_model','search',[["field", "operator", "value"]], 10 , 0 )
        response
      end

    end

    context "without limit and offset" do



    it_behaves_like "any object request"

    it "invokes execute with model_name, search, [params], 0, 0" do
      ServerStub::Object::Connection.prologue.should_receive(:execute)
      .with('receiver_model','search',[["field", "operator", "value"]], 0,0)
      response
    end
    end

    context "successful request" do
      before(:each) { ServerStub::Object::Search.successful }
      let(:response) { ReceiverModel.search(user_context, [["field", "operator", "value"]]) }

      it_behaves_like "any successful request"

      it "response.content should be an Array" do
        response.content.should be_an Array
      end

    end

    context "failed request" do
      before(:each) do
        ServerStub::Object::Search.failure
      end

      it_behaves_like "any failed request"

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

    context "failed request" do
      before(:each) do
        ServerStub::Object::Read.failure
      end

      it_behaves_like "any failed request"

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

    context "failed request" do
      before(:each) do
        ServerStub::Object::Write.failure
      end

      it_behaves_like "any failed request"

    end

  end

  describe ".create(user_context,{field:value})" do
    before(:each) do
      allow_message_expectations_on_nil
      ServerStub::Object::Create.prologue
    end

    let(:response) { ReceiverModel.create(user_context,{field:'value'})}

    it_behaves_like "any object request"

    it "invokes execute with model_name, 'create', {field:'value'}" do
      ServerStub::Object::Connection.prologue.should_receive(:execute)
      .with('receiver_model', 'create', {field:'value'})
      response
    end

    context "successful request" do
      before(:each) do
        ServerStub::Object::Create.successful
      end

      it_behaves_like "any successful request"

      it "reponse.content should be 1" do
        response.content.should be 1
      end

    end

    context "failed request" do
      before(:each) do
        ServerStub::Object::Create.failure
      end

      it_behaves_like "any failed request"

    end

  end

end