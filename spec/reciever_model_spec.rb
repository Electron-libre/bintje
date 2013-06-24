require 'spec_helper'

describe 'reciever model' do
  before(:each) { openerp_settings }

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

      it "should set the openerp model name with the given string" do
        ReceiverModel.set_openerp_model "another_name"
        ReceiverModel.openerp_model.should eql "another_name"
      end

    end

    describe ".connection(user_context:{dbname:String,uid:Fixnum,pwd:String})" do
      let(:user_context) { {dbname:'dbname', uid:2,pwd:'pwd' }}

      it "should build a new XMLRPC connection" do
        allow_message_expectations_on_nil
        XMLRPC::Client.should_receive(:new)
        .with(Openerp.host,Openerp.object,Openerp.port)
        .and_return().should_receive(:proxy)
        ReceiverModel.connection(user_context)
      end



    end

  end

end