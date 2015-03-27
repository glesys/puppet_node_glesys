require 'puppet/cloudpack_glesys'
require 'puppet/face/node_glesys'

Puppet::Face.define :node_glesys, '0.0.1' do
  action :stop do
    summary 'Stop GleSYS machine instance.'
    description <<-EOT
      This action stops a GleSYS machine instance.
    EOT
    Puppet::CloudPackGleSYS.add_stop_options(self)
    when_invoked do |options|
      Puppet::CloudPackGleSYS.stop(options)
    end
  end
end
