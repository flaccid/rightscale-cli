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
  class Deployments < Thor
    namespace :deployments
    
    desc "show", "Lists all deployments."
    def show()
      option :xml, :type => :boolean, :default => false, :aliases => '-X', :desc => 'Return XML.'
      
      deployments = Array.new
      RightApi::Client.new(RightScaleCLI::Config::API).deployments.index.each { |deployment|
        deployments.push(deployment.raw)
      }  
      puts deployments.to_yaml
    end

    desc "create", "Creates a deployment."
    def create(name)
      rightscale = RightApi::Client.new(RightScaleCLI::Config::API)

    end

    desc "destroy", "Deletes a deployment."
    def destroy(deployment)
      rightscale = RightApi::Client.new(RightScaleCLI::Config::API)
      
      # construct deployment
      deployment = Hash.new
      rightscale.deployments.delete({:deployment => deployment})
    end

    def self.banner(task, namespace = true, subcommand = false)
      "#{basename} #{task.formatted_usage(self, true, subcommand)}"
    end
  end
end
