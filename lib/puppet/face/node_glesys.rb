require 'puppet/face'

Puppet::Face.define(:node_glesys, '0.0.1') do
  copyright "Puppet Labs, GleSYS Internet Services AB", 2011 .. 2015
  license   "Apache 2 license; see LICENSE"

  summary "View and manage GleSYS nodes."
  description <<-'EOT'
    This subcommand provides a command line interface to work with GleSYS
    machine instances.  The goal of these actions is to easily create new
    machines, install Puppet onto them, and tear them down when they're no longer
    required.
  EOT
end
