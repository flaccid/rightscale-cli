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
require 'rightscale_cli/config'
require 'rightscale_cli/logger'
require 'rightscale_cli/client'
require 'ask_pass'
require 'erb'
require "base64"

class RightScaleCLI
  class Configure < Thor
    namespace :configure

    def initialize(*args)
      super
      @logger = RightScaleCLI::Logger.new()
      @config = RightScaleCLI::Config.new
      @directives = @config.directives
    end

    no_commands{
    def update_conf()
      File.open(@config.config_path, 'w') {|f| f.write(ERB.new(IO.read(@config.template_path)).result(binding)) }
    end
    }

    desc "account", "Configure the RightScale account ID for the client."
    def account()
      @directives.merge!( { :account_id => ask("RightScale account ID (e.g. 1337):")})
      update_conf
    end

    desc "user", "Configure the RightScale user for the client."
    def user()
      @directives.merge!( { :email => ask("RightScale username (e.g. bill.gates@microsoft.com):") })
      update_conf
    end

    desc "password", "Configure the RightScale user password for the client."
    def password()
      @directives.merge!( { :password_base64 => Base64.encode64(ask_pass).strip })
      update_conf
    end

    desc "api", "Configure the RightScale API version used by the client."
    def api()
      @directives.merge!( { :api_version => ask("RightScale API version (e.g. 1.5):") })
      update_conf
    end

    desc "shard", "Configure the RightScale shard used by the client."
    def shard()
      @directives.merge!( { :api_url => "https://#{ask("RightScale shard (e.g. us-4.rightscale.com):")}" })
      update_conf
    end

    desc "show", "Print the current configuration from ~/.rightscale/right_api_client.yml."
    def show()
      puts @directives
    end

    desc "all", "Configure RightScale CLI."
    def all()
      # currently this is the lazy way, each is written sequentially
      account
      user
      password
      shard
      api
      puts 'Configuration saved.'
    end

    #default_task :all

    def self.banner(task, namespace = true, subcommand = false)
      "#{basename} #{task.formatted_usage(self, true, subcommand)}"
    end
  end
end
