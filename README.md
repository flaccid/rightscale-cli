# RightScale CLI

[![Gem Version](https://fury-badge.herokuapp.com/rb/rightscale-cli.png)](http://badge.fury.io/rb/rightscale-cli)

RightScale CLI client. Currently in early development stages.
For more information, see https://rubygems.org/gems/rightscale-cli.

## Installation

Ruby >= 1.9.3 is required. Using rbenv or RVM is recommended, or install the gem from RubyGems.org:

    $ gem install rightscale-cli

### Debian/Ubuntu

If you are installing on a Debian or Ubuntu release that currently has Ruby 1.8 installed, upgrade by taking the following steps.

Remove Ruby 1.8:

    # apt-get remove --purge libruby1.8 ruby ruby1.8

Install Ruby 1.9.3:

    # apt-get install ruby1.9.3 rubygems1.9.1

Re-install RightLink if on a RightScale server (removing ruby removes it), for example on EC2:

    # apt-get install rightlink rightlink-cloud-ec2
    # service rigtscale start
    # service rightlink start
    
Then, install the gem: 

    # gem install rightscale-cli

Ensure system uses ruby1.9:

    # update-alternatives --set ruby /usr/bin/ruby1.9.1
    
### Mac OS X, FreeBSD

The executable, `rs` will conflict with `RS(1)` on Mac OS X (http://www.freebsd.org/cgi/man.cgi?query=rs&sektion=1&apropos=0&manpath=freebsd).

As a result, to avoid overwriting the `/usr/bin/rs` binary, use a different location in your `~/.gemrc` or `/etc/gemrc`, for example:

    gem: --bindir /usr/local/bin

## Configuration

This can easily be done interactively with the tool once installed:

    $ rs configure all

Or, manually setup `~/.rightscale/right_api_client.yml` with your RightScale credentials.
Ensure the correct shard for your account is set with `:api_url`.
An example file is available, https://github.com/rightscale/right_api_client/blob/master/config/login.yml.example.

## Usage

There is one command, `rs`.

 * For a list of commands, type `rs help`
 * For a list of subcommands, type `rs <namespace> help`, e.g. `rs arrays help`
 * For usage options of a subcommand, type `rs <namespace> help <subcommand>`, e.g. `rs arrays help instances`

### Examples

List all clouds within your account:

    $ rs clouds list

## License and Authors

* Author:: Chris Fordham <chris [at] fordham [hyphon] nagy [dot] id [dot] au>

* Copyright:: 2013, Chris Fordham

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.