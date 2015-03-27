require 'puppet/cloudpack_glesys'
require 'puppet/face/node_glesys'

Puppet::Face.define :node_glesys, '0.0.1' do
  action :status do
    summary 'Get status for GleSYS machine instances.'
    description <<-'EOT'
      This action gets status for a GleSYS machine instance
      and displays it on console output.
    EOT
    Puppet::CloudPackGleSYS.add_details_options(self)
    when_invoked do |options|
      Puppet::CloudPackGleSYS.details(options)
    end
    when_rendering :console do |value|
      value.collect do |k,v|
        "#{k}: #{v}"
      end.sort.join("\n")
    end
    returns 'Array of attribute hashes containing status for one instance.'
  end
end
