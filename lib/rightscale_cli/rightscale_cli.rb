# Author:: Chris Fordham (<chris@fordham-nagy.id.au>)
# Copyright:: Copyright (c) 2013 Chris Fordham
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'thor'
require 'rightscale_cli/config'
require 'rightscale_cli/logger'
require 'rightscale_cli/configure'
require 'rightscale_cli/clouds'
require 'rightscale_cli/dashboard'
require 'rightscale_cli/deployments'
require 'rightscale_cli/instances'
require 'rightscale_cli/multi_cloud_images'
require 'rightscale_cli/repositories'
require 'rightscale_cli/servers'
require 'rightscale_cli/server_arrays'
require 'rightscale_cli/server_templates'
require 'rightscale_cli/tags'
require 'rightscale_cli/volumes'

# http://stackoverflow.com/questions/5663519/namespacing-thor-commands-in-a-standalone-ruby-executable

class RightScaleCLI
  class Base < Thor
    class_option :account,
      :type => :string,
      :aliases => '-a',
      :required => false,
      :desc => 'RightScale account ID.'

    class_option :user,
      :type => :string,
      :aliases => '-u',
      :required => false,
      :desc => 'RightScale user.'

    class_option :password,
      :type => :boolean,
      :aliases => '-p',
      :required => false,
      :desc => 'RightScale user password.'

    class_option :api,
      :type => :string,
      :aliases => '-A',
      :required => false,
      :desc => 'RightScale API version.'

    class_option :debug,
      :type => :boolean,
      :default => false,
      :aliases => '-D',
      :desc => 'Debug mode.'

    class_option :verbose,
      :type => :boolean,
      :default => false,
      :aliases => '-V',
      :desc => 'Verbose output.'

    class_option :silent,
      :type => :boolean,
      :default => false,
      :aliases => '-S',
      :desc => 'Silent mode, do not print any log.'

    class_option :non_interactive,
      :type => :boolean,
      :default => false,
      :aliases => '-N',
      :desc => 'Non-interactive mode.'

    class_option :dry,
      :type => :boolean,
      :default => false,
      :desc => 'Dry-run only.'

    register(Configure, 'configure', 'configure <command>', 'Configure the RightScale credentials used by the client.')
    register(Clouds, 'clouds', 'clouds <command>', 'Query clouds.')
    register(Dashboard, 'dashboard', 'dashboard <command>', 'RightScale Dashboard (HTTP hax).')
    register(ServerArrays, 'arrays', 'arrays <command>', 'Manage server arrays.')
    register(Deployments, 'deployments', 'deployments <command>', 'Manage deployments.')
    register(Instances, 'instances', 'instances <command>', 'Manage instances.')
    register(MultiCloudImages, 'mcis', 'mcis <command>', 'Manage MultiCloud Images.')
    register(Repositories, 'repositories', 'repositories <command>', 'Manage (Chef) Repositories.')
    register(Servers, 'servers', 'servers <command>', 'Manage servers.')
    register(ServerTemplates, 'server_templates', 'server-templates <command>', 'Manage ServerTemplates.')
    register(Tags, 'tags', 'tags <command>', 'Manage tags.')
    register(Volumes, 'volumes', 'volumes <command>', 'Manage volumes.')
  end
end
