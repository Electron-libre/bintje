require 'spec_helper'

describe Openerp do
  context 'for common URI' do

    before :each do
      openerp_settings
    end

    describe '.common_client' do
      it 'build new XMLRPC connection client Proxy' do
        allow_message_expectations_on_nil
        XMLRPC::Client.should_receive(:new).with('localhost','/xmlrpc/common','8069').and_return().should_receive(:proxy).with(nil)
        Openerp.common_client
      end
    end

    describe '.login' do
      it "require dbname, user_name, password" do
        XMLRPC::Client::Proxy.any_instance.stub(:login).with('dbname','user', 'password')
        Openerp.login('dbname', 'user', 'password')
      end

      it "respond with Runtime error when authentication fails" do
        XMLRPC::Client::Proxy.any_instance.stub(:login).with('dbname','user', 'password').and_return()
        Openerp.login
      end



      it "respons with user id when authentication is successfull"

    end

  end



end