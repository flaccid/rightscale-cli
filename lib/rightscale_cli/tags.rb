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
  class Tags < Thor
    namespace :tags

    def initialize(*args)
      super
      @client = RightScaleCLI::Client.new(options)
      @logger = RightScaleCLI::Logger.new()
    end

    # include render options
    eval(IO.read("#{File.dirname(File.expand_path(__FILE__))}/render_options.rb"), binding)

    desc "search", "Search for resources having a list of tags in a specific resource_type."
    def search()
      # todo
    end

    desc "resource", "Get tags for a list of resource hrefs."
    def resource(resource_hrefs)
      @client.client.tags.by_resource(:resource_hrefs => resource_hrefs.split(','))
    end

    desc "add", "Adds tag(s) to resource(s)."
    def add(hrefs, tags)
      @client.client.tags.multi_add(:resource_hrefs => [hrefs.split(',')], :tags => [tags.split(',')])
    end

    desc "delete", "Deletes tags from resource(s)."
    def delete(hrefs, tags)
      @client.client.tags.multi_delete(:resource_hrefs => [hrefs.split(',')], :tags => [tags.split(',')])
    end

    def self.banner(task, namespace = true, subcommand = false)
      "#{basename} #{task.formatted_usage(self, true, subcommand)}"
    end
  end
end