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
require 'rightscale_cli/client'
require 'rightscale_cli/logger'

class RightScaleCLI
  class Instances < Thor
    namespace :instances

    def initialize(*args)
      super
      @client = RightScaleCLI::Client.new(options)
      @logger = RightScaleCLI::Logger.new()
    end

    # include render options
    eval(IO.read(
      "#{File.dirname(File.expand_path(__FILE__))}/render_options.rb"), binding
    )

    desc "list", "Lists all instances for a given cloud."
    option :cloud, :desc => 'The cloud to filter on.', :type => :string, :required => true
    option :datacenter, :desc => 'The href of the datacenter to filter on', :type => :string, :required => false
    option :deployment, :desc =>  'The href of the deployment to filter on.', :type => :string, :required => false
    option :name, :desc => 'Name of the Instance to filter on.', :type => :string, :required => false
    option :os, :desc => 'The OS platform to filter on.', :type => :string, :required => false
    option :parent, :desc => 'The href of the parent to filter on.', :type => :string, :required => false
    option :private_dns => 'The private dns name to filter on.', :type => :string, :required => false
    option :private_ip, :desc => 'The private ip address to filter on.', :type => :string, :required => false
    option :public_dns, :desc => 'The public dns name to filter on.', :type => :string, :required => false
    option :public_ip, :desc => 'The public ip address to filter on.', :type => :string, :required => false
    option :resource_uid, :desc => 'Resource Unique IDentifier for the Instance to filter on.', :type => :string, :required => false
    option :server_template, :desc => 'The href of the ServerTemplate to filter on.', :type => :string, :required => false
    option :state, :desc => 'The state of Instances to filter on.', :type => :string, :required => false
    def list()
      filter = []
      filter.push("datacenter_href==#{options[:datacenter]}") if options[:datacenter]
      filter.push("deployment_href==#{options[:deployment]}") if options[:deployment]
      filter.push("name==#{options[:private_ip]}") if options[:name]
      filter.push("os_platform==#{options[:os]}") if options[:os]
      filter.push("parent_href==#{options[:parent]}") if options[:parent]
      filter.push("private_dns_name==#{options[:private_dns]}") if options[:private_dns]
      filter.push("private_ip_address==#{options[:private_ip]}") if options[:private_ip]
      filter.push("public_dns==#{options[:public_dns]}") if options[:public_dns]
      filter.push("public_ip_address==#{options[:public_ip]}") if options[:public_ip]
      filter.push("resource_uid==#{options[:resource_uid]}") if options[:resource_uid]
      filter.push("server_template_href==#{options[:server_template]}") if options[:server_template]
      filter.push("state==#{options[:state]}") if options[:state]

      @logger.debug "filter: #{filter}" if options[:debug]

      instances = []
      @client.client.clouds(:id => options[:cloud]).show.instances(:filter => filter).index.each do |instance|
        instance_href = instance.href
        instance = instance.raw
        instance['href'] = instance_href
        instances.push(instance)
      end
      @client.render(instances, 'instances')
    end

    desc "show", "Shows attributes of a single instance."
    option :cloud, :desc => 'The cloud to filter on.', :type => :string, :required => true
    def show(instance_id)
      filter = []
      @client.render(@client.client.clouds(:id => options[:cloud]).show.instances.index(:id => instance_id).show.raw, 'instance')
    end

    desc "run-exec", "Runs a chef recipe or rightscript on instances of a given cloud."
    option :cloud, :desc => 'The cloud to filter on.', :type => :string, :required => true
    option :datacenter, :desc => 'The href of the datacenter to filter on', :type => :string, :required => false
    option :deployment, :desc =>  'The href of the deployment to filter on.', :type => :string, :required => false
    option :name, :desc => 'Name of the Instance to filter on.', :type => :string, :required => false
    option :os, :desc => 'The OS platform to filter on.', :type => :string, :required => false
    option :parent, :desc => 'The href of the parent to filter on.', :type => :string, :required => false
    option :private_dns => 'The private dns name to filter on.', :type => :string, :required => false
    option :private_ip, :desc => 'The private ip address to filter on.', :type => :string, :required => false
    option :public_dns, :desc => 'The public dns name to filter on.', :type => :string, :required => false
    option :public_ip, :desc => 'The public ip address to filter on.', :type => :string, :required => false
    option :resource_uid, :desc => 'Resource Unique IDentifier for the Instance to filter on.', :type => :string, :required => false
    option :server_template, :desc => 'The href of the ServerTemplate to filter on.', :type => :string, :required => false
    option :state, :desc => 'The state of Instances to filter on.', :type => :string, :required => false
    def run_exec(exec_type, exec_identifier)
      params = {}
      filter = []

      if exec_type == 'recipe'
        params['recipe_name'] = exec_identifier
      elsif exec_type == 'rightscript'
        params['right_script_href'] = "/api/right_scripts/#{exec_identifier}"
      end

      filter.push("datacenter_href==#{options[:datacenter]}") if options[:datacenter]
      filter.push("deployment_href==#{options[:deployment]}") if options[:deployment]
      filter.push("name==#{options[:private_ip]}") if options[:name]
      filter.push("os_platform==#{options[:os]}") if options[:os]
      filter.push("parent_href==#{options[:parent]}") if options[:parent]
      filter.push("private_dns_name==#{options[:private_dns]}") if options[:private_dns]
      filter.push("private_ip_address==#{options[:private_ip]}") if options[:private_ip]
      filter.push("public_dns==#{options[:public_dns]}") if options[:public_dns]
      filter.push("public_ip_address==#{options[:public_ip]}") if options[:public_ip]
      filter.push("resource_uid==#{options[:resource_uid]}") if options[:resource_uid]
      filter.push("server_template_href==#{options[:server_template]}") if options[:server_template]
      filter.push("state==#{options[:state]}") if options[:state]

      params['filter'] = filter
      @logger.debug "filter: #{filter}" if options[:debug]
      @logger.debug "params: #{params}" if options[:debug]
      
      @client.client.clouds(:id => options[:cloud]).show.instances.multi_run_executable(params)
    end
    
    def self.banner(task, namespace = true, subcommand = false)
      "#{basename} #{task.formatted_usage(self, true, subcommand)}"
    end
  end
end
