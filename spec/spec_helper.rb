require 'rubygems'

require 'bintje'

RSpec.configure do |config|
end

require 'server_stub'

def openerp_settings
  Openerp.host = 'localhost'
  Openerp.port = '8069'
  Openerp.common = '/xmlrpc/common'
  Openerp.object = '/xmlrpc/object'
end