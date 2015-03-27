require 'puppet/cloudpack_glesys'
require 'puppet/face/node_glesys'

Puppet::Face.define :node_glesys, '0.0.1' do
  action :templates do

    summary 'List GleSYS machine templates.'

    description <<-'EOT'
      This action obtains a list of templates from GleSYS and
      displays them on the console output.
    EOT

    Puppet::CloudPackGleSYS.add_templates_options(self)

    when_invoked do |options|
      Puppet::CloudPackGleSYS.templates(options)
    end

    when_rendering :console do |value|
      value.collect do |name,status_hash|
        "#{name}:\n" + status_hash.collect do |field, val|
          "  #{field}: #{val}"
        end.sort.join("\n")
      end.sort.join("\n")
    end

    returns 'Array of attribute hashes containing basic information about each instance.'

    examples <<-'EOT'
      List every instance:

          $ puppet node_glesys list
         wps1066151:
           datacenter: Falkenberg
           hostname: apoapsis
           platform: VMware
           serverid: wps1066151
         wps2409955:
          datacenter: Stockholm
          hostname: periapsis
          platform: VMware
          serverid: wps2409955
    EOT
  end
end
