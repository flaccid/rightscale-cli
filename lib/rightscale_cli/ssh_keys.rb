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
  # interface /api/clouds/ssh_keys
  class SSHKeys < Thor
    namespace :ssh_keys

    def initialize(*args)
      super
      @client = RightScaleCLI::Client.new(options)
      @logger = RightScaleCLI::Logger.new
    end

    # include render options
    eval(IO.read(
      "#{File.dirname(File.expand_path(__FILE__))}/render_options.rb"), binding
    )

    desc 'list', 'Lists all SSH keys in a cloud.'
    option :cloud,
           desc: 'The cloud to filter on.',
           type: 'string',
           required: true
    option :uid,
           desc: 'Resource Unique IDentifier for the SSH key to filter on.',
           type: 'string',
           required: false,
           default: false
    def list
      filter = [].push("resource_uid==#{options[:uid]}") if options[:uid]

      results = @client.client.clouds(
        id: options[:cloud]
      ).show.ssh_keys(filter: filter).index

      ssh_keys = []
      results.each do |result|
        ssh_key = result.raw
        ssh_key['href'] = result.href
        ssh_keys.push(ssh_key)
      end

      @client.render(ssh_keys, 'ssh_keys')
    end

    desc 'show', 'Shows a SSH key in a cloud.'
    option :cloud,
           desc: 'The cloud the SSH key resides in.',
           type: 'string',
           required: true
    def show(ssh_key_id)
      @client.render(@client.client.clouds(id: options[:cloud]).show.ssh_keys(id: ssh_key_id).show.raw, 'ssh_key')
    end

    desc 'create', 'Creates an SSH key in a cloud.'
    def create(name)
      # todo
    end

    desc 'destroy', 'Deletes an SSH key in a cloud.'
    def destroy(server)
      # todo
    end

    def self.banner(task, namespace = true, subcommand = false)
      "#{basename} #{task.formatted_usage(self, true, subcommand)}"
    end
  end
end
