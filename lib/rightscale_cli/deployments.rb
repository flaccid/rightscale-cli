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
require 'yaml'
require 'rightscale_cli/client'
require 'rightscale_cli/logger'
require 'rightscale_cli/config'
require 'deployment_cat'
require 'right_api_client'

class RightScaleCLI
  # Represents RightScale Deployments
  class Deployments < Thor
    namespace :deployments

    def initialize(*args)
      super
      @client = RightScaleCLI::Client.new(options)
      @logger = RightScaleCLI::Logger.new
      @config = RightScaleCLI::Config.new.directives
    end

    class_option :xml,
                 type: :boolean,
                 default: false,
                 aliases: '-X',
                 required: false,
                 desc: 'returns xml'
    class_option :json,
                 type: :boolean,
                 default: false,
                 aliases: '-J',
                 required: false,
                 desc: 'returns json'

    desc 'list', 'Lists all deployments'
    def list
      @client.render(@client.get('deployments'), 'deployments')
    end

    desc 'create', 'Creates a deployment'
    def create(name, description)
      @client.create('deployment', name: name, description: description)
    end

    desc 'destroy', 'Deletes a deployment'
    def destroy(deployment_id)
      @client.destroy('deployment', deployment_id)
    end

    desc 'servers', 'Lists servers in a deployment'
    def servers(deployment)
      @logger.info("Retrieving all servers in deployment, #{deployment}...")
      @client.render(@client.show('deployments', deployment, 'servers'),
                     'servers')
    end

    desc 'terminate', 'Terminates all servers in a deployment'
    def terminate(deployment_id)
      @client.client.deployments.index(id: deployment_id)
        .show.servers.index.each do |server|
        unless server.state == 'inactive'
          @logger.info "Terminating #{server.href} (state: #{server.state}.)"
          server.terminate
        end
      end
    end

    desc 'export', 'Exports a deployment into a CAT file'
    def export(deployment_id)
      @config[:timeout] = nil
      @client = RightApi::Client.new(@config)
      deployment_to_cat_file @client, deployment_id, nil, nil
    end

    def self.banner(task, _namespace = true, subcommand = false)
      "#{basename} #{task.formatted_usage(self, true, subcommand)}"
    end
  end
end
