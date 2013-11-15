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
require 'right_api_client'
      
class RightScaleCLI
  class Servers < Thor
    namespace :servers

    desc "show", "Lists all servers."
    def show()
      servers = Array.new
      RightApi::Client.new(RightScaleCLI::Config::API).servers.index.each { |deployment|
        servers.push(deployment.raw)
      }  
      puts servers.to_yaml
    end

    desc "create", "Creates a server."
    def create(name)
      rightscale = RightApi::Client.new(RightScaleCLI::Config::API)

    end

    desc "destroy", "Deletes a server."
    def destroy(server)
      rightscale = RightApi::Client.new(RightScaleCLI::Config::API)
      
      # construct deployment
      server = Hash.new
      rightscale.servers.delete({:server => server})
    end

    def self.banner(task, namespace = true, subcommand = false)
      "#{basename} #{task.formatted_usage(self, true, subcommand)}"
    end
  end
end
