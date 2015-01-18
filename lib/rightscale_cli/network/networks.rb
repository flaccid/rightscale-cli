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
require 'rightscale_cli/client'
require 'rightscale_cli/logger'

class RightScaleCLI
  # Represents Network Manager Networks
  class Networks < Thor
    namespace :networks

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

    desc 'list', 'lists all networks'
    def list
      filter = []
      @logger.debug "filter: #{filter}" if options[:debug]

      networks = []
      @client.client.networks.index(filter: filter).each do |network|
        networks.push(network)
      end
      @client.render(networks, 'networks')
    end

    def self.banner(task, _namespace = true, subcommand = false)
      "#{basename} #{task.formatted_usage(self, true, subcommand)}"
    end
  end
end
