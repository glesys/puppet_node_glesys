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

    def add_ssh_key_list_options(action)
      add_credential_option(action)
    end

    def add_bootstrap_options(action)
      add_create_options(action)
      add_init_options(action)
    end

    def add_init_options(action)
      add_install_options(action)
    end

    def add_install_options(action)
      action.option '--login=' do
        summary 'User to log in to the instance as.'
        description <<-EOT
          The name of the user Puppet should use when logging in to the node.
          This user should configured to allow passwordless access via the SSH
          key supplied in the `--keyfile` option.
        EOT
        default_to { 'root' }
      end

      action.option '--privatekey=' do
        summary "The path to a local SSH private key (or 'agent' if using an agent)."
        description <<-EOT
          The filesystem path to a local private key that can be used to SSH
          into the node. If the node was created with the `node_glesys` `create`
          action, this should be the path to the private key corresponding
          to the `--sshkeyids` option.

          Specify 'agent' if you have the key loaded in ssh-agent and
          available via the SSH_AUTH_SOCK variable.
        EOT
#        should be required, but we can use password auth for now
#        required
        before_action do |action, arguments, options|
          # If the user specified --privatekey=agent, check for SSH_AUTH_SOCK
          if options[:privatekey].downcase == 'agent' then
            # Force the option value to lower case to make it easier to test
            # for 'agent' in all other sections of the code.
            options[:privatekey].downcase!
            # Check if the user actually has access to an Agent.
            if ! ENV['SSH_AUTH_SOCK'] then
              raise ArgumentError,
                "SSH_AUTH_SOCK environment variable is not set and you specified --privatekey agent.  Please check that ssh-agent is running correctly, and that SSH agent forwarding is not disabled."
            end
            # We break out of the before action block because we don't really
            # have anything else to do to support ssh agent authentication.
            break
          end

          privatekey = File.expand_path(options[:privatekey])
          unless test 'f', privatekey
            raise ArgumentError, "Could not find file '#{privatekey}'"
          end
          unless test 'r', privatekey
            raise ArgumentError, "Could not read from file '#{privatekey}'"
          end
        end
      end

      action.option '--install-shellscript=' do
        summary 'An installer shellscript which should be run on the server.'
        description <<-EOT
          Name of a local shellscript to automatically be copied to the server
          and executed to perform all post-installation tasks.'
        EOT
        default_to { 'examples/setup_glesys_server.sh' }
      end

    end

    def bootstrap(options)
      server = self.create(options)
      Puppet.notice "Waiting for server to come online"
      server.wait_for { ready? }
      ipaddr = server.iplist[0]["ipaddress"]
      Puppet.notice "Waiting for SSH daemon on #{ipaddr}:22"
      timeout = 60
      until self.is_port_open?(ipaddr, 22) or timeout <= 0 do
        Puppet.notice("#{timeout} seconds ...")
        timeout = timeout - 5
        sleep(5)
      end
      Puppet.notice "Proceeding with init"
      self.init(server, options)
      return nil
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
      return server
    end

    def init(server, options)
      install_status = install(server, options)
      certname = install_status['puppetagent_certname']

      Puppet.notice "Puppet is now installed on: #{server.hostname}"

      # HACK: This should be reconciled with the Certificate Face.
      cert_options = {:ca_location => :remote}

      # TODO: Wait for C.S.R.?

      Puppet.notice "Signing certificate ..."
      begin
        Puppet::Face[:certificate, '0.0.1'].sign(certname, cert_options)
        Puppet.notice "Signing certificate ... Done"
      rescue Puppet::Error => e
        # TODO: Write useful next steps.
        Puppet.err "Signing certificate ... Failed"
        Puppet.err "Signing certificate error: #{e}"
        exit(1)
      rescue Net::HTTPError => e
        # TODO: Write useful next steps
        Puppet.warning "Signing certificate ... Failed"
        Puppet.err "Signing certificate error: #{e}"
        exit(1)
      end
    end

    def install(server, options)

      # If the end user wants to use their agent, we need to set privatekey to nil
      if options[:privatekey] == 'agent' then
        options[:privatekey] = nil
      end

      ipaddr = server.iplist[0]["ipaddress"]

      connections = ssh_connect(ipaddr, options[:login], options[:privatekey], options[:rootpassword])

      upload_payloads(connections[:scp], options)

      # Finally, execute the installer script
      install_command = "/usr/bin/env sh /root/setup_glesys_server.sh"
      results = ssh_remote_execute(ipaddr, options[:login], install_command, options[:privatekey], options[:rootpassword])
      if results[:exit_code] != 0 then
        raise Puppet::Error, "The installer script exited with a non-zero exit status, indicating a failure.  It may help to run with --debug to see the script execution or to check the installation log file on the remote system in #{options[:tmp_dir]}."
      end

      # At this point we may assume installation of Puppet succeeded since the
      # install script returned with a zero exit code.

      # Determine the certificate name as reported by the remote system.
      certname_command = "puppet agent --configprint certname"
      results = ssh_remote_execute(ipaddr, options[:login], certname_command, options[:privatekey], options[:rootpassword])

      if results[:exit_code] == 0 then
        puppetagent_certname = results[:stdout].strip
      else
        Puppet.warning "Could not determine the remote puppet agent certificate name using #{certname_command}"
        puppetagent_certname = nil
      end

      # Return value
      {
        'status'               => 'success',
        'puppetagent_certname' => puppetagent_certname,
        'stdout'               => results[:stdout],
      }
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

    def ssh_key_list(options)
      connection = create_connection(options)
      ssh_keys = connection.ssh_keys
      hsh = {}
      ssh_keys.each do |k|
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
      Puppet.notice('Creating new server ...')
      server = servers.create(options)
      Puppet.notice("Creating new server ... Done")
      return server
    end

    def ssh_remote_execute(server, login, command, privatekey = nil, password = nil)
      Puppet.notice "Executing remote command ..."
      Puppet.notice "Command: #{command}"
      buffer = String.new
      stdout = String.new
      exit_code = nil
      # Figure out the options we need to pass to start.  This allows us to use SSH_AUTH_SOCK
      # if the end user specifies --privatekey=agent
      ssh_opts = privatekey ? { :keys => [ privatekey ] } : { :password => password }
      # Start
      begin
        Net::SSH.start(server, login, ssh_opts) do |session|
          session.open_channel do |channel|
            channel.request_pty
            channel.on_data do |ch, data|
              buffer << data
              stdout << data
              if buffer =~ /\n/
                lines = buffer.split("\n")
                buffer = lines.length > 1 ? lines.pop : String.new
                lines.each do |line|
                  Puppet.notice(line)
                end
              end
            end
            channel.on_eof do |ch|
              # Display anything remaining in the buffer
              unless buffer.empty?
                Puppet.notice(buffer)
              end
            end
            channel.on_request("exit-status") do |ch, data|
              exit_code = data.read_long
              Puppet.debug("SSH Command Exit Code: #{exit_code}")
            end
            # Finally execute the command
            channel.exec(command)
          end
        end
      rescue Net::SSH::AuthenticationFailed => user
        raise Net::SSH::AuthenticationFailed, "Authentication failure for user #{user}. Please check the privatekey and try again."
      end

      Puppet.info "Executing remote command ... Done"
      { :exit_code => exit_code, :stdout => stdout }
    end

    def ssh_connect(server, login, privatekey = nil, password = nil)
      opts = {}
      # This allows SSH_AUTH_SOCK agent usage if privatekey is nil
      opts[:password] = password if password
# XXX find out why this doesn't work
#      opts[:key_data] = [File.read(File.expand_path(privatekey))] if privatekey
      ssh = Fog::SSH.new(server, login, opts)
      scp = Fog::SCP.new(server, login, opts)
      {:ssh => ssh, :scp => scp}
    end

    def upload_payloads(scp, options)
        Puppet.notice "Uploading install script #{options[:install_shellscript]}..."
        scp.upload(options[:install_shellscript], "/root/setup_glesys_server.sh")
        Puppet.notice "Uploading install script ... Done"
    end

    def is_port_open?(ip, port)
      begin
        Timeout::timeout(1) do
          begin
        s = TCPSocket.new(ip, port)
        s.close
        return true
          rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
            return false
          end
        end
      rescue Timeout::Error
      end
      return false
    end

  end
end
