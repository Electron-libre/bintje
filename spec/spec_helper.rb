require 'rubygems'

require 'bintje'

RSpec.configure do |config|
end

require 'server_stub'

def open_object_settings
  OpenObject.host = 'localhost'
  OpenObject.port = '8069'
  OpenObject.common = '/xmlrpc/common'
  OpenObject.object = '/xmlrpc/object'
end