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
require 'rightscale_cli/client'
require 'rightscale_cli/logger'

class RightScaleCLI
  class MultiCloudImages < Thor
    namespace :mcis

    def initialize(*args)
      super
      @client = RightScaleCLI::Client.new(options)
      @logger = RightScaleCLI::Logger.new()
    end

    # include render options
    eval(IO.read("#{File.dirname(File.expand_path(__FILE__))}/render_options.rb"), binding)

    desc "list", "Lists all MultiCloud Images."
    def list()
      @logger.info('Retrieving all MultiCloud Images...')
      @client.render(@client.get('multi_cloud_images'), 'multi_cloud_images')
    end

    desc "show", "Shows a particular MultiCloud Image."
    def show(multi_cloud_image_id)
      @client.render(@client.show('multi_cloud_images', multi_cloud_image_id), 'multi_cloud_image')
    end
    
    desc "create", "Creates a MultiCloud Image."
    def create(name, description)
      @client.create('multi_cloud_image', { :name => name, :description => description })
    end

    desc "destroy", "Deletes a MultiCloud Image."
    def destroy(multi_cloud_image_id)
      @client.destroy('multi_cloud_image', multi_cloud_image_id)
    end

    def self.banner(task, namespace = true, subcommand = false)
      "#{basename} #{task.formatted_usage(self, true, subcommand)}"
    end
  end
end
