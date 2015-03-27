require 'puppet/cloudpack_glesys'
require 'puppet/face/node_glesys'

Puppet::Face.define :node_glesys, '0.0.1' do
  action :details do

    summary 'Get details for GleSYS machine instances.'

    description <<-'EOT'
      This action gets details for a GleSYS machine instance
      and displays them on console output.
    EOT

    Puppet::CloudPackGleSYS.add_status_options(self)

    when_invoked do |options|
      Puppet::CloudPackGleSYS.status(options)
    end

    when_rendering :console do |value|
      value.collect do |k,v|
        "#{k}: #{v}"
      end.sort.join("\n")
    end

    returns 'Array of attribute hashes containing details for one instance.'
  end
end
