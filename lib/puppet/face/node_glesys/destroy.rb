require 'puppet/cloudpack_glesys'
require 'puppet/face/node_glesys'

Puppet::Face.define :node_glesys, '0.0.1' do
  action :destroy do
    summary 'Destroy GleSYS machine instance.'
    description <<-'EOT'
      This action destroys a GleSYS machine instance.
    EOT
    Puppet::CloudPackGleSYS.add_destroy_options(self)
    when_invoked do |options|
      Puppet::CloudPackGleSYS.destroy(options)
    end
  end
end
