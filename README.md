# node_glesys

#### Table of Contents

1. [Overview](#overview)
2. [Quickstart](#setup)
    * [Install build tools](#quickstart-tools)
    * [Install puppet in your home directory](#quickstart-puppet)
    * [Build and install fog.io with additional GleSYS support](#quickstart-fog)
    * [Build and install the GleSYS module for puppet](#quickstart-build)
    * [Configure GleSYS user credentials](#quickstart-configure)
    * [Start exploring puppet face commands](#quickstart-done)
3. [Production setup](#production-setup)

## Overview

This module provides [Puppet Faces](https://puppetlabs.com/faces/feed) commands for working
with virtual servers hosted on the GleSYS platform. `node_glesys` also provides bootstrapping capabilities similar to
[Puppet Cloud Provisioner](https://docs.puppetlabs.com/pe/latest/cloudprovisioner_overview.html).

## Quickstart

### Install build tools

```
$ sudo apt-get install git ruby ruby-dev build-essential libz-dev
```

### Install puppet in your home directory

```
$ gem install --verbose --user-install puppet
```

### Install fog.io

```
$ gem install --verbose --user-install -version ">= 1.29.0" fog
```

### Build and install the GleSYS module for puppet

```
$ git clone git@github.com:GleSYS/puppet_node_glesys.git
$ cd puppet_node_glesys
$ ~/.gem/ruby/1.9.1/bin/puppet module build
$ ~/.gem/ruby/1.9.1/bin/puppet module install pkg/glesys-node_glesys-0.0.1.tar.gz
```

### Configure GleSYS user credentials

Create a file called `~/.fog` and place the following in it:

```
:default:
  :glesys_username: CLxxxxx
  :glesys_api_key: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

Get your API key from: https://customer.glesys.com/#api/keys

### Start exploring puppet face commands

```
$  ~/.gem/ruby/1.9.1/bin/puppet help node_glesys
...
$  ~/.gem/ruby/1.9.1/bin/puppet node_glesys create --hostname=mytestserver --rootpassword=supersecret
...
```

## Production setup

Assuming you have installed the node_glesys module on your puppet master and/or your workstation is allowed to sign new host certificates, the following should work:
```
puppet node_glesys bootstrap \
--hostname=app1.dev.mydomain.com \
--rootpassword=supersecret \
--install-shellscript=examples/setup_glesys_server.sh
```

... and should produce output silimar to this:

```
Notice: Creating new server ...
Notice: Creating new server ... Done
Notice: Created GleSYS server vz2313626 with hostname app1.dev.mydomain.com.
Notice: Waiting for server to come online
Notice: Waiting for SSH daemon on 159.253.24.23:22
Notice: 60 seconds ...
Notice: Proceeding with init
Notice: Uploading install script examples/setup_glesys_server.sh...
Notice: Uploading install script ... Done
Notice: Executing remote command ...
Notice: Command: /usr/bin/env sh /root/setup_glesys_server.sh
[installation tasks run]
[....] Starting puppet agent.
Notice: Executing remote command ...
Notice: Command: puppet agent --configprint certname
Notice: app1.dev.mydomain.com
Notice: Puppet is now installed on: app1.dev.mydomain.com
Notice: Signing certificate ...
Notice: Signing certificate ... Done
```

Note that you must to customize `setup_glesys_server.sh` according to your specific site requirements so that your new server can find it's Puppet Master.

