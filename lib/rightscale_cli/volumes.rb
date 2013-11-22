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

class RightScaleCLI
  class Volumes < Thor
    namespace :volumes

    # include render options
    eval(IO.read("#{File.dirname(File.expand_path(__FILE__))}/render_options.rb"), binding)
    
    desc "list", "Lists volumes, optionally with filter by datacenter, description, name, parent volume snapshot or resource UID."
    option :cloud, :desc => "The cloud to query for volumes in.", :type => :string, :required => true
    option :datacenter, :desc => "The href of the Datacenter / Zone the Volume is in.", :type => :string, :required => false
    option :description, :desc => "The description of the Volume to filter on.", :type => :string, :required => false
    option :name, :desc => "The name of the Volume to filter on.", :type => :string, :required => false
    option :parent, :desc => "The href of the snapshot from which the volume was created.", :type => :string, :required => false
    option :resource_uid, :desc => "Resource Unique IDentifier for the Volume to filter on.", :type => :string, :required => false

    def list()
      volumes = []      
      filter = []

      filter.push("datacenter_href==/api/clouds/#{options[:cloud]}/datacenters/#{options[:datacenter]}") if options[:datacenter]
      filter.push("description==#{options[:description]}") if options[:description]
      filter.push("name==#{options[:name]}") if options[:name]
      filter.push("parent_volume_snapshot_href==#{options[:parent]}") if options[:parent]
      filter.push("resource_uid==#{options[:resource_uid]}") if options[:resource_uid]

      $log.debug "filter: #{filter}" if options[:debug]

      RightApi::Client.new(RightScaleCLI::Config::API).clouds(:id => options[:cloud]).show.volumes(:filter => filter).index.each { |volume|
        volumes.push(volume.raw)
      }

      RightScaleCLI::Output.render(volumes, 'volumes', options)
    end

    desc "show", "Shows a volume."
    option :cloud, :desc => "The cloud to query for volumes in.", :type => :string, :required => true
    def show(volume_id)
      volume = RightApi::Client.new(RightScaleCLI::Config::API).clouds(:id => options[:cloud]).show.volumes(:id => volume_id).show.raw
      RightScaleCLI::Output.render(volume, 'volume', options)
    end

    def self.banner(task, namespace = true, subcommand = false)
      "#{basename} #{task.formatted_usage(self, true, subcommand)}"
    end
  end
end
