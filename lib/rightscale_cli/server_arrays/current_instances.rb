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

require 'rightscale_cli/logger'
require 'rightscale_cli/output'

class RightScaleCLI
  class ServerArrays < Thor

    desc "instances", "Shows a server array's current instances, optionally with filters.", :type => :string, :required => false
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

    def instances(server_array_id)
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

      array_instances = []
      @client.client.server_arrays(:id => server_array_id).show.current_instances(:filter => filter).index.each { |array_instance|
        array_instances.push(array_instance.raw)
      }

      @client.render(array_instances, 'array_instances')
    end
  end
end
