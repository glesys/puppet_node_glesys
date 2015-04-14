require 'puppet/face/node_glesys'
require 'puppet/cloudpack_glesys'

Puppet::Face.define :node_glesys, '0.0.1' do
  action :ssh_key_list do
    summary 'List saved SSH keys.'
    description <<-'EOT'
      This action lists the SSH pubkeys that have been saved on the GleSYS account.
      Any key id from this list is a valid argument for the create action's
      --sshkeyids option.
    EOT
    Puppet::CloudPackGleSYS.add_ssh_key_list_options(self)
    when_invoked do |options|
      Puppet::CloudPackGleSYS.ssh_key_list(options)
    end
    when_rendering :console do |value|
      value.collect do |id,hash|
        "#{id}: #{hash['description']}"
      end.sort.join("\n")
    end
    returns 'Array of attribute hashes containing information about each SSH pubkey'
    examples <<-'EOT'
      List the available key pairs:

          $ puppet node_glesys ssh_key_list
          707: test_ed25519
          708: test_ecdsa

      Get the key pair list as an array of JSON hashes:

          $ puppet node_glesys ssh_key_list --render-as json
          {
            "707":{
              "id":707,
              "description":"test_ed25519",
              "data":"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDv+r ..."
            },
            "708":{
              "id":708,
              "description":"test_ecdsa",
              "data":"ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItb ..."
            }
          }
    EOT
  end
end
