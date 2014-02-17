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
require 'rightscale_cli/logger'
require 'rightscale_cli/client'
require 'rightscale_cli/server_arrays/alerts'
require 'rightscale_cli/server_arrays/alert_specs'
require 'rightscale_cli/server_arrays/current_instances'
require 'rightscale_cli/server_arrays/elasticity_params'
require 'rightscale_cli/server_arrays/links'
require 'rightscale_cli/server_arrays/multi_run_executable'

class RightScaleCLI
  class ServerArrays < Thor
    namespace :arrays

    def initialize(*args)
      super
      @client = RightScaleCLI::Client.new(options)
      @logger = RightScaleCLI::Logger.new()
    end

    # include render options
    eval(IO.read("#{File.dirname(File.expand_path(__FILE__))}/render_options.rb"), binding)
    
    desc "list", "Lists server arrays, optionally with filter by cloud, deployment, name."
    option :cloud, :type => :string, :required => false
    option :deployment, :type => :string, :required => false
    option :name, :type => :string, :required => false
    def list()
      filter = []
      filter.push("cloud_href==/api/clouds/#{options[:cloud]}") if options[:cloud]
      filter.push("deployment_href==/api/deployments/#{options[:cloud]}") if options[:deployment]
      filter.push("name==#{options[:name]}") if options[:name]

      @logger.debug "filter: #{filter}" if options[:debug]
      
      server_arrays = []
      @client.client.server_arrays.index(:filter => filter).each { |server_array|
        server_arrays.push(server_array.raw)
      }

      @client.render(server_arrays, 'server_arrays')
    end

    desc "show", "Shows a particular server array."
    def show(server_array_id)
      @client.render(@client.show('server_arrays', server_array_id), 'server_array')
    end

    desc "state", "Shows the state of a server array."
    def state(server_array_id)
      @logger.info "Retrieving state for server array, #{server_array_id}."
      puts @client.client.server_arrays(:id => server_array_id).show.state
    end

    desc "instances_count", "Shows the instances count of a server array."
    def instances_count(server_array_id)
      @logger.info "Retrieving instances count for server array, #{server_array_id}."
      puts @client.client.server_arrays(:id => server_array_id).show.instances_count
    end

    desc "desc", "Shows the description of a server array."
    def desc(server_array_id)
      @logger.info "Retrieving description for server array, #{server_array_id}."
      puts @client.client.server_arrays(:id => server_array_id).show.description
    end

    desc "name", "Shows the name of a server array."
    def name(server_array_id)
      @logger.info "Retrieving name for server array, #{server_array_id}."
      puts @client.client.server_arrays(:id => server_array_id).show.name
    end
    
    desc "api_methods", "Lists the API methods available to a server array."
    def api_methods(server_array_id)
      @logger.info "Retrieving API methods for server array, #{server_array_id}."
      puts @client.client.server_arrays(:id => server_array_id).show.api_methods
    end

    desc "inputs", 'Update the inputs of the server array.'
    def inputs(server_array_id)
      @client.render(@client.show('server_arrays', server_array_id), 'server_array')
    end

    desc "next", 'Show the next instance properties of the server array.'
    def next(server_array_id)
      @client.render(@client.client.server_arrays(:id => server_array_id).show.next_instance.index)
    end

    def self.banner(task, namespace = true, subcommand = false)
      "#{basename} #{task.formatted_usage(self, true, subcommand)}"
    end
  end
end
