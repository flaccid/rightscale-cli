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
  # Represents Network Manager Security Groups
  class SecurityGroups < Thor
    namespace :secgroups

    def initialize(*args)
      super
      @client = RightScaleCLI::Client.new(options)
      @logger = RightScaleCLI::Logger.new
    end

    # include render options
    eval(IO.read(
      "#{File.dirname(File.expand_path(__FILE__))}/../render_options.rb"), binding
    )

    desc 'list', 'Lists all security groups.'
    option :cloud,
           desc: 'The cloud to filter on.',
           type: :string,
           required: true
    def list
      filter = []

      @logger.debug "filter: #{filter}" if options[:debug]

      security_groups = []
      @client.client.clouds(id: options[:cloud])\
        .show.security_groups(filter: filter).index.each do |sec_group|
        security_groups.push(sec_group)
      end
      @client.render(security_groups, 'security_groups')
    end

    desc 'show', 'Shows a single security group.'
    def show(secgroup_id)
      filter = []
      @client.render(@client.client.clouds(id: options[:cloud]).show.instances.index(id: instance_id).show.raw, 'instance')
    end

    desc 'create', 'Creates a security group.'
    option :cloud,
           desc: 'The cloud to filter on.',
           type: :string,
           required: true
    def create(name, description=false)
      @client.create('security_group',
                     cloud: options[:cloud],
                     security_group: { name: name, description: description })
    end

    desc 'create_rs_mgmt', 'Creates a new security group with ' \
      'rules needed for outbound traffic to RightScale.'
    option :cloud,
           desc: 'The cloud to filter on.',
           type: :string,
           required: true
    def create_rs_mgmt(network_id)
      sg_href = @client.create('security_group',
                               cloud: options[:cloud],
                               security_group: {
                                 name: 'mgmt-rightscale-egress',
                                 description: 'Enables all RightScale ' \
                                 'use cases (end-user access to UI and ' \
                                 'API, RightLink system management, ' \
                                 'monitoring, alerting).',
                                 network_href: "/api/networks/#{network_id}" })
      sg_rules = [
        {
          cidr_ips: '54.187.254.128/26',
          security_group_href: sg_href,
          source_type: 'cidr_ips',
          protocol: 'all',
          direction: 'egress'
        },
        {
          cidr_ips: '54.225.248.128/27',
          security_group_href: sg_href,
          source_type: 'cidr_ips',
          protocol: 'all',
          direction: 'egress'
        },
        {
          cidr_ips: '54.244.88.96/27',
          security_group_href: sg_href,
          source_type: 'cidr_ips',
          protocol: 'all',
          direction: 'egress'
        },
        {
          cidr_ips: '54.246.247.16/28',
          security_group_href: sg_href,
          source_type: 'cidr_ips',
          protocol: 'all',
          direction: 'egress'
        },
        {
          cidr_ips: '54.255.255.208/28',
          security_group_href: sg_href,
          source_type: 'cidr_ips',
          protocol: 'all',
          direction: 'egress'
        },
        {
          cidr_ips: '54.86.63.128/26',
          security_group_href: sg_href,
          source_type: 'cidr_ips',
          protocol: 'all',
          direction: 'egress'
        },
        {
          cidr_ips: '0.0.0.0/0',
          security_group_href: sg_href,
          source_type: 'cidr_ips',
          protocol: 'udp',
          protocol_details: {
            start_port: '3011',
            end_port: '3011'
          },
          direction: 'egress'
        }
      ]
      sg_rules.each do |rule|
        @logger.info rule
        @client.create('security_group_rule', security_group_rule: rule)
      end
      @logger.info 'Please remember to delete the outbound ' \
        '0.0.0.0/0 rule now (TODO: automatically delete).'
    end

    def self.banner(task, namespace = true, subcommand = false)
      "#{basename} #{task.formatted_usage(self, true, subcommand)}"
    end
  end
end
