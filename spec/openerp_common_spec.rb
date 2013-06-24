require 'spec_helper'
require 'request_shared_examples'

describe "Openerp" do
  context 'for common context' do

    before :each do
      openerp_settings
    end

    describe '.common_client' do
      it 'build new XMLRPC connection client Proxy' do
        allow_message_expectations_on_nil
        XMLRPC::Client.should_receive(:new)
        .with('localhost', '/xmlrpc/common', '8069')
        .and_return().should_receive(:proxy).with(nil)
        Openerp.common_client
      end
    end

    describe '.login' do

      context 'with wrong database name' do
        before(:each) do
          ServerStub::Common::Login.wrong_data_base_name
        end
        let(:response) { Openerp.login('dbname', 'user', 'password') }

        it_behaves_like "any failed request"

        it " response.errors : #{ServerStub::Common::Login.wrong_database_name_fault_code}" do
          response.errors.should include(ServerStub::Common::Login.wrong_database_name_fault_code)
        end

      end

      context 'with wrong user name and/or password' do
        before(:each) do
          ServerStub::Common::Login.wrong_user_name
        end
        let(:response) { Openerp.login('dbname', 'user', 'password') }

        it_behaves_like "any failed request"

      end


      context 'on successful authentication request' do
        before(:each) do
          ServerStub::Common::Login.successful
        end
        let(:response) { Openerp.login('dbname', 'user', 'password') }

        it_behaves_like 'any successful request'

        it "response.content.class = Fixnum (user id)" do
          response.content.class.should be Fixnum
        end

        it "response.content == #{ServerStub::Common::Login.uid} (expected user id)" do
          response.content.should be ServerStub::Common::Login.uid
        end

      end


    end

  end


end