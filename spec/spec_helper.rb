require 'rubygems'
require 'bintje'

RSpec.configure do |config|
end

require 'server_stub'
require 'logger'

def open_object_settings
  OpenObject.host = 'localhost'
  OpenObject.port = '8069'
  OpenObject.common = '/xmlrpc/common'
  OpenObject.object = '/xmlrpc/object'
  OpenObject.logger = Logger.new(File::NULL)
end
