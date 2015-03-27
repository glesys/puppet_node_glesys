require 'fog'

# GleSYS Adaption of Puppet::CloudPack from Puppet Cloud Provisioner

module Puppet::CloudPackGleSYS
  class InstanceErrorState < Exception
  end

  class << self

    def add_credential_option(action)
      action.option '--credentials=' do
        summary 'Cloud credentials to use from ~/.fog'
        description <<-EOT
          For accessing more than a single account, auxiliary credentials other
          than 'default' may be supplied in the credentials location (usually
          ~/.fog).
        EOT
      end
    end

    def add_datacenter_option(action)
      action.option '--datacenter=' do
        summary 'Data center used to create machine instance.'
        description <<-EOT
          The data center used to create new machine instances.
          Currently, GleSYS have data centers in Stockholm and Falkenberg.
        EOT
        default_to { 'Stockholm' }
      end
    end

    def add_platform_option(action)

      action.option '--platform=' do
        summary 'Platform used to create machine instance.'
        description <<-EOT
          The Cloud platform used to create new machine instances.
          Currently, GleSYS supports OpenVZ and VMware.
        EOT
        default_to { 'OpenVZ' }
      end
    end

    def add_hostname_option(action)
      action.option "--hostname=" do
        summary "Hostname used to create machine instance."
        description <<-EOT
          Hostname used to create machine instance. This is a required option
          and must be unique for the current account.
        EOT
        required
      end
    end

    def add_templatename_option(action)
      action.option '--templatename=' do
        summary 'Template name used to create machine instance.'
        description <<-EOT
        Template name used to create machine instance. Note that templates with
        whitespace in the name must be quoted, e.g. -t="Debian 7.0 32-bit".
        Use "puppet node_glesys templates" to list the available templates.
        EOT
        default_to { "Debian 7.0 32-bit" }
      end
    end

    def add_disksize_option(action)
      action.option '--disksize=' do
        summary 'Disk size in gigabytes used to create machine instance.'
        description <<-EOT
        Disk size in gigabytes used to create machine instance.
        EOT
        default_to { "5" }
      end
    end

    def add_memorysize_option(action)
      action.option '--memorysize=' do
        summary 'Memory size in megabytes used to create machine instance.'
        description <<-EOT
        Memory size in megabytes used to create machine instance.
        EOT
        default_to { "512" }
      end
    end

    def add_cpucores_option(action)
      action.option '--cpucores=' do
        summary 'Number of CPU cores used to create machine instance.'
        description <<-EOT
        Number of CPU cores used to create machine instance.
        EOT
        default_to { "1" }
      end
    end

    def add_rootpassword_option(action)
      action.option '--rootpassword=' do
        summary 'Root password used to create machine instance.'
        description <<-EOT
        Root password used to create machine instance.
        EOT
        required
      end
    end

    def add_description_option(action)
      action.option '--description=' do
        summary 'Description used to create machine instance.'
        description <<-EOT
        Description used to create machine instance.
        EOT
        default_to { "" }
      end
    end

    def add_ip_option(action)
      action.option '--ip=' do
        summary 'IP version 4 address used to create machine instance.'
        description <<-EOT
        IP version 4 address used to create machine instance.
        Use "any" to allocate an address from the pool. Use "none" to skip assignment.
        EOT
        default_to { "any" }
      end
    end

    def add_ipv6_option(action)
      action.option '--ipv6=' do
        summary 'IP version 6 address used to create machine instance.'
        description <<-EOT
        IP version 6 address used to create machine instance.
        Use "any" to allocate an address from the pool. Use "none" to skip assignment.
        EOT
        default_to { "any" }
      end
    end

    def add_bandwidth_option(action)
      action.option '--bandwidth=' do
        summary 'Bandwidth limit in Megabits/second'
        description <<-EOT
        Bandwidth limit in Megabits/second."
        EOT
        default_to { "10" }
      end
    end

    def add_sshkeyids_option(action)
      action.option '--sshkeyids=' do
        summary 'SSH public key ids used to create machine instance.'
        description <<-EOT
        A comma separate list of integers for SSH public keys saved on the account.
        Use "node_glesys sshkey_list" to find valid key ids.
        EOT
      end
    end

    def add_sshkey_option(action)
      action.option '--sshkey=' do
        summary 'SSH public key used to create machine instance.'
        description <<-EOT
        A SSH public key line to be added to root's authorized_keys file.
        EOT
      end
    end

    def add_serverid_option(action)
      action.option '--serverid=' do
        summary 'Server id key used to manage existing machine instance.'
        description <<-EOT
        A serverid as returned by "puppet node_glesys list".
        EOT
        required
      end
    end

    def add_keepip_option(action)
      action.option '--keepip=' do
        summary 'Keep IP address allocatiion when destroying server.'
        description <<-EOT
        Boolean value (1 or 0) depending on whether you want
        to keep the IP assignment for later reuse.
        EOT
        default_to { "0" }
      end
    end

    def add_create_options(action)
      add_credential_option(action)
      add_datacenter_option(action)
      add_platform_option(action)
      add_hostname_option(action)
      add_templatename_option(action)
      add_disksize_option(action)
      add_memorysize_option(action)
      add_cpucores_option(action)
      add_rootpassword_option(action)

      add_description_option(action)
      add_ip_option(action)
      add_ipv6_option(action)
      add_bandwidth_option(action)
      add_sshkeyids_option(action)
      add_sshkey_option(action)
    end

    def add_destroy_options(action)
      add_credential_option(action)
      add_serverid_option(action)
      add_keepip_option(action)
    end

    def add_reboot_options(action)
      add_credential_option(action)
      add_serverid_option(action)
    end

    def add_stop_options(action)
      add_credential_option(action)
      add_serverid_option(action)
    end

    def add_start_options(action)
      add_credential_option(action)
      add_serverid_option(action)
    end

    def add_details_options(action)
      add_credential_option(action)
      add_serverid_option(action)
    end

    def add_status_options(action)
      add_credential_option(action)
      add_serverid_option(action)
    end

    def add_list_options(action)
      add_credential_option(action)
    end

    def add_templates_options(action)
      add_credential_option(action)
    end

    def add_sshkey_list_options(action)
      add_credential_option(action)
    end

    def create(options)
      connection = create_connection(options)
      server = create_server(connection.servers, {
                               :datacenter => options[:datacenter],
                               :platform => options[:platform],
                               :hostname => options[:hostname],
                               :templatename => options[:templatename],
                               :disksize => options[:disksize],
                               :memorysize => options[:memorysize],
                               :cpucores => options[:cpucores],
                               :rootpassword => options[:rootpassword],
                               :description => options[:description],
                               :ip => options[:ip],
                               :ipv6 => options[:ipv6],
                               :bandwidth => options[:bandwidth],
                               :sshkeyids => options[:sshkeyids],
                               :sshkey => options[:sshkey]
                             }
      )
      Puppet.notice("Created GleSYS server #{server.serverid} with hostname #{server.hostname}.")
      # return server.iplist[0]["ipaddress"]
      return server.serverid
    end

    def reboot(options)
      connection = create_connection(options)
      resp = connection.reboot(:serverid => options[:serverid])
      Puppet.notice("Response text: #{resp[:body]["response"]["status"]["text"]}")
      true
    end

    def stop(options)
      connection = create_connection(options)
      resp = connection.stop(:serverid => options[:serverid])
      Puppet.notice("Response text: #{resp[:body]["response"]["status"]["text"]}")
      true
    end

    def start(options)
      connection = create_connection(options)
      resp = connection.start(:serverid => options[:serverid])
      Puppet.notice("Response text: #{resp[:body]["response"]["status"]["text"]}")
      true
    end

    def destroy(options)
      connection = create_connection(options)
      resp = connection.destroy(:serverid => options[:serverid], :keepip => options[:keepip])
      Puppet.notice("Response text: #{resp[:body]["response"]["status"]["text"]}")
      true
    end

    def sshkey_list(options)
      connection = create_connection(options)
      sshkeys = connection.sshkeys
      hsh = {}
      sshkeys.each do |k|
        hsh[k.id] = {
          "id"          => k.id,
          "description" => k.description,
          "data"        => k.data
        }
      end
      hsh
    end

    def list(options)
      connection = create_connection(options)
      servers = connection.servers
      hsh = {}
      servers.each do |s|
        hsh[s.serverid] = {
          "serverid"   => s.serverid,
          "hostname"   => s.hostname,
          "datacenter" => s.datacenter,
          "platform"   => s.platform
        }
      end
      hsh
    end

    def templates(options)
      connection = create_connection(options)
      templates = connection.templates
      hsh = {}
      templates.each do |t|
        hsh[t.name] = {
          "name"       => t.name,
          "platform"   => t.platform
        }
      end
      hsh
    end

    def details(options)
      connection = create_connection(options)
      resp = connection.server_details(options[:serverid])
      details = resp.body["response"]["server"]
    end

    def status(options)
      connection = create_connection(options)
      resp = connection.server_status(options[:serverid])
      status = resp.body["response"]["server"]
    end

    def create_connection(options = {})
      Fog.credential = options[:credentials].to_sym if options[:credentials]
      Fog::Compute.new(:provider => "GleSYS")
    end

    def create_server(servers, options = {})
      Puppet.notice('Creating new instance ...')
      server = servers.create(options)
      Puppet.notice("Creating new instance ... Done")
      return server
    end

  end
end
