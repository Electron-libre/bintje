require 'spec_helper'

describe Openerp do
  describe '.login' do
    it "require dbname, user_name, password" do
      Openerp.login('dbname', 'user', 'password')

    end
  end

end