require 'spec_helper'

describe Openerp do
  describe '.login' do
    it "require dbname, user_name, password" do
      Openerp.host = 'localhost'
      Openerp.port = '8069'
      Openerp.common = '/xmlrpc/common'

      Openerp.login('dbname', 'user', 'password')

    end
  end

end