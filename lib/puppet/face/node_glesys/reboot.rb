require 'puppet/cloudpack_glesys'
require 'puppet/face/node_glesys'

Puppet::Face.define :node_glesys, '0.0.1' do
  action :reboot do
    summary 'Reboot GleSYS machine instance.'
    description <<-EOT
      This action reboots a GleSYS instance.
    EOT
    Puppet::CloudPackGleSYS.add_reboot_options(self)
    when_invoked do |options|
      Puppet::CloudPackGleSYS.reboot(options)
    end
  end
end
