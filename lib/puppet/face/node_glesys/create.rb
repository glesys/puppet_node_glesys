require 'puppet/cloudpack_glesys'
require 'puppet/face/node_glesys'

Puppet::Face.define :node_glesys, '0.0.1' do
  action :create do
    summary 'Create a new GleSYS machine instance.'
    description <<-EOT
      This action launches a new GleSYS instance and returns the server ID.

      A newly created system may not be immediately ready after launch while
      it boots. You can use the `ready` action to wait for the system to
      become ready after launch. (XXX not yet implemented)
    EOT
    Puppet::CloudPackGleSYS.add_create_options(self)
    when_invoked do |options|
      Puppet::CloudPackGleSYS.create(options)
    end
  end
end
