require 'puppet/cloudpack_glesys'
require 'puppet/face/node_glesys'

Puppet::Face.define :node_glesys, '0.0.1' do
  action :start do
    summary 'Start GleSYS machine instance.'
    description <<-EOT
      This action starts a GleSYS machine instance.
    EOT
    Puppet::CloudPackGleSYS.add_start_options(self)
    when_invoked do |options|
      Puppet::CloudPackGleSYS.start(options)
    end
  end
end
