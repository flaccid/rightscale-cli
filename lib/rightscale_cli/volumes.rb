# Author:: Chris Fordham (<chris@fordham-nagy.id.au>)
# Copyright:: Copyright (c) 2013-2015 Chris Fordham
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

class RightScaleCLI
  # Represents Storage Volumes
  class Volumes < Thor
    namespace :volumes

    def initialize(*args)
      super
      @client = RightScaleCLI::Client.new(options)
      @logger = RightScaleCLI::Logger.new
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

    desc 'list', 'lists volumes, optionally with filter by datacenter, ' \
      'description, name, parent volume snapshot or resource UID'
    option :cloud,
           desc: 'the cloud to query for volumes in',
           type: :string,
           required: true
    option :datacenter,
           desc: 'the href of the datacenter / zone the volume is in',
           type: :string,
           required: false
    option :description,
           desc: 'the description of the Volume to filter on',
           type: :string,
           required: false
    option :name,
           desc: 'the name of the Volume to filter on',
           type: :string,
           required: false
    option :parent,
           desc: 'the href of the snapshot from which the volume was created',
           type: :string,
           required: false
    option :resource_uid,
           desc: 'a resource unique identifier for the volume to filter on',
           type: :string,
           required: false
    def list
      filter = []
      filter.push("datacenter_href==/api/clouds/#{options[:cloud]}/datacenters/#{options[:datacenter]}") if options[:datacenter]
      filter.push("description==#{options[:description]}") if options[:description]
      filter.push("name==#{options[:name]}") if options[:name]
      filter.push("parent_volume_snapshot_href==#{options[:parent]}") if options[:parent]
      filter.push("resource_uid==#{options[:resource_uid]}") if options[:resource_uid]

      @logger.debug "filter: #{filter}" if options[:debug]

      volumes = []
      @client.client.clouds(id: options[:cloud])
        .show.volumes(filter: filter).index.each do |volume|
        volumes.push(volume.raw)
      end

      @client.render(volumes, 'volumes')
    end

    desc 'show', 'shows a single volume'
    option :cloud,
           desc: 'the cloud to query for volumes in',
           type: :string,
           required: true
    def show(volume_id)
      @client.render(@client.client.clouds(id: options[:cloud])
        .show.volumes(id: volume_id).show.raw, 'volume')
    end

    def self.banner(task, _namespace = true, subcommand = false)
      "#{basename} #{task.formatted_usage(self, true, subcommand)}"
    end
  end
end
