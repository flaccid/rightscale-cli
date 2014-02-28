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
require 'rightscale_cli/client'
      
class RightScaleCLI
  class RecurringVolumeAttachments < Thor
    namespace :re_attachments

    def initialize(*args)
      super
      @client = RightScaleCLI::Client.new(options)
      @logger = RightScaleCLI::Logger.new
    end

    # include render options
    eval(IO.read("#{File.dirname(File.expand_path(__FILE__))}/render_options.rb"), binding)
    
    desc "list", "Lists all recurring volume/snapshot attachments."
    option :cloud, :desc => 'The cloud to filter on.', :type => :string, :required => true
    def list()
      attachments = []
      filter = []
      @client.client.clouds(:id => options[:cloud]).show.recurring_volume_attachments(:filter => filter).index.each do |attach|
        attachments.push(attach)
      end
      @client.render(attachments, 'recurring_volume_attachments')
    end


    def self.banner(task, namespace = true, subcommand = false)
      "#{basename} #{task.formatted_usage(self, true, subcommand)}"
    end
  end
end
