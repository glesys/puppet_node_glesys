require 'puppet/cloudpack_glesys'
require 'puppet/face/node_glesys'

Puppet::Face.define :node_glesys, '0.0.1' do
  action :bootstrap do
    summary 'Create and initialize a GleSYS instance using Puppet.'
    description <<-EOT
      Creates an instance, runs a provided shell script on it to install the
      puppet agent, and signs the instance's certificate.
    EOT
    Puppet::CloudPackGleSYS.add_bootstrap_options(self)
    when_invoked do |options|
      Puppet::CloudPackGleSYS.bootstrap(options)
    end
  end
end
