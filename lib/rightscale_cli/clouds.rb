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
  class Clouds < Thor
    namespace :clouds

    def initialize(*args)
      super
      @client = RightScaleCLI::Client.new(options)
      @logger = RightScaleCLI::Logger.new()
    end

    # include render options
    eval(IO.read("#{File.dirname(File.expand_path(__FILE__))}/render_options.rb"), binding)

    desc "list", "Lists all clouds."
    option :basic, :type => :boolean, :required => false
    def list()
      clouds = @client.get('clouds')

      if options[:basic]
        basic_fields = [ 'display_name', 'cloud_type', 'name' ]
        basic_clouds = []
        @client.get('clouds').each { |cloud|
          cloud_id = cloud['links'].select { |link| link['rel'] == 'instances' }.first['href'].split('/')[3]
          c = cloud.select{|x| basic_fields.include?(x)}
          c['cloud_id'] = cloud_id
          basic_clouds.push(c)
        }
        clouds = basic_clouds
      end

      @client.render(clouds, 'clouds')
    end

    desc "show", "Shows a cloud."
    def show(cloud_id)
      @client.render(@client.show('clouds', cloud_id), 'cloud')
    end

    desc "search", "Searches for clouds by cloud type, name, description."
    option :name, :type => :string, :required => false
    option :cloud_type, :type => :string, :required => false
    option :description, :type => :string, :required => false
    def search()
      filter = []
      filter.push("name==#{options[:name]}") if options[:name]
      filter.push("cloud_type==#{options[:cloud_type]}") if options[:cloud_type]
      filter.push("description==#{options[:cloud]}") if options[:description]

      @logger.info "Searching for clouds!"

      puts "filter: #{filter}" if options[:debug]
      
      clouds = []
      @client.client.clouds.index(:filter => filter).each { |cloud|
        clouds.push(cloud.raw)
      }  

      @client.render(clouds, 'clouds')
    end

    def self.banner(task, namespace = true, subcommand = false)
      "#{basename} #{task.formatted_usage(self, true, subcommand)}"
    end
  end
end
