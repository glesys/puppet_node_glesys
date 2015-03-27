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
    returns 'Array of attribute hashes containing information about templates.'
    examples <<-'EOT'
      List all templates:

     $ puppet node_glesys templates
     Centos 6 32-bit:
       name: Centos 6 32-bit
       platform: OpenVZ
     Centos 6 64-bit:
       name: Centos 6 64-bit
       platform: OpenVZ
    EOT
  end
end
