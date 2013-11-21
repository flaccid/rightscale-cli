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
require 'json'
require "active_support/core_ext"
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

    # include render options
    eval(IO.read("#{File.dirname(File.expand_path(__FILE__))}/render_options.rb"), binding)
    
    desc "list", "Lists server arrays, optionally with filter by cloud, deployment, name."
    option :cloud, :type => :string, :required => false
    option :deployment, :type => :string, :required => false
    option :name, :type => :string, :required => false
    def list()
      rightscale = RightApi::Client.new(RightScaleCLI::Config::API)
  
      filter = []
      filter.push("cloud_href==/api/clouds/#{options[:cloud]}") if options[:cloud]
      filter.push("deployment_href==/api/deployments/#{options[:cloud]}") if options[:deployment]
      filter.push("name==#{options[:name]}") if options[:name]

      $log.debug "filter: #{filter}" if options[:debug]
      
      server_arrays = []
      rightscale.server_arrays.index(:filter => filter).each { |server_array|
        server_arrays.push(server_array.raw)
      }

      if options[:xml]
        puts server_arrays.to_xml(:root => 'server_arrays')
      elsif options[:json]
        puts JSON.pretty_generate(server_arrays)
      else
        puts server_arrays.to_yaml
      end
    end

    desc "show", "Shows a server array."
    def show(server_array_id)
      rightscale = RightApi::Client.new(RightScaleCLI::Config::API)

      server_array = rightscale.server_arrays(:id => server_array_id).show.raw

      if options[:xml]
        puts server_array.to_xml(:root => 'server_array')
      elsif options[:json]
        puts JSON.pretty_generate(server_array)
      else
        puts server_array.to_yaml
      end
    end
    
    desc "state", "Shows the state of a server array."
    def state(server_array_id)
      $log.info "Retrieving state for server array, #{server_array_id}."
      rightscale = RightApi::Client.new(RightScaleCLI::Config::API)
      puts rightscale.server_arrays(:id => server_array_id).show.state
    end

    desc "instances_count", "Shows the instances count of a server array."
    def instances_count(server_array_id)
      $log.info "Retrieving instances count for server array, #{server_array_id}."
      rightscale = RightApi::Client.new(RightScaleCLI::Config::API)
      puts rightscale.server_arrays(:id => server_array_id).show.instances_count
    end

    desc "desc", "Shows the description of a server array."
    def desc(server_array_id)
      $log.info "Retrieving description for server array, #{server_array_id}."
      rightscale = RightApi::Client.new(RightScaleCLI::Config::API)
      puts rightscale.server_arrays(:id => server_array_id).show.description
    end

    desc "name", "Shows the name of a server array."
    def name(server_array_id)
      $log.info "Retrieving name for server array, #{server_array_id}."
      rightscale = RightApi::Client.new(RightScaleCLI::Config::API)
      puts rightscale.server_arrays(:id => server_array_id).show.name
    end
    
    desc "api_methods", "Lists the API methods available to a server array."
    def api_methods(server_array_id)
      $log.info "Retrieving API methods for server array, #{server_array_id}."
      rightscale = RightApi::Client.new(RightScaleCLI::Config::API)
      server_array = rightscale.server_arrays(:id => server_array_id).show.api_methods
      puts server_array
    end

    def self.banner(task, namespace = true, subcommand = false)
      "#{basename} #{task.formatted_usage(self, true, subcommand)}"
    end
  end
end
