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
    * [Automatically register new servers with your puppet master](#bootstrap)

## Overview

This module provides [Puppet Faces](https://puppetlabs.com/faces/feed) commands for working
with virtual servers hosted on the GleSYS platform. In the future `node_glesys` will also provide
classification and bootstrapping capabilities similar to
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

### Build and install fog.io with additional GleSYS support

```
$ git clone git@github.com:tnn2/fog.git
$ cd fog
$ git checkout glesys_sshkeys
$ gem build fog.gemspec
$ gem install --verbose --user-install ./fog-1.28.0.gem
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

### Automatically register new servers with your puppet master

This is not yet available but will be supported soon.
