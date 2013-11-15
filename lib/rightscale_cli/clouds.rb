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

class RightScaleCLI
  class Clouds < Thor
    namespace :clouds

    desc "list", "Lists all clouds."
    def list()
      rightscale = RightApi::Client.new(RightScaleCLI::Config::API)
      clouds = []
      rightscale.clouds.index.each { |cloud|
        clouds.push(cloud.raw)
      }  
      puts clouds.to_yaml
    end

    desc "show", "Shows a cloud."
    def show(cloud_id)
      rightscale = RightApi::Client.new(RightScaleCLI::Config::API)
      cloud = rightscale.clouds(:id => cloud_id).show.raw
      puts cloud.to_yaml
    end

    desc "search", "Searches for clouds by cloud type, name, description."
    option :name, :type => :string, :required => false
    option :cloud_type, :type => :string, :required => false
    option :description, :type => :string, :required => false
    def search()
      log = CLILogger.new

      filter = []
      filter.push("name==#{options[:name]}") if options[:name]
      filter.push("cloud_type==#{options[:cloud_type]}") if options[:cloud_type]
      filter.push("description==#{options[:cloud]}") if options[:description]

      log.info("Searching for clouds!")

      puts "filter: #{filter}" if options[:debug]
      
      rightscale = RightApi::Client.new(RightScaleCLI::Config::API)      
      clouds = []
      rightscale.clouds.index(:filter => filter).each { |cloud|
        clouds.push(cloud.raw)
      }  
      puts clouds.to_yaml
    end

    def self.banner(task, namespace = true, subcommand = false)
      "#{basename} #{task.formatted_usage(self, true, subcommand)}"
    end
  end
end
