require 'rubygems'

require 'bintje'

RSpec.configure do |config|
end

def openerp_settings
  Openerp.host = 'localhost'
  Openerp.port = '8069'
  Openerp.common = '/xmlrpc/common'
end