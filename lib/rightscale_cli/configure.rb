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
      @conf_template_path = File.join(File.dirname(__FILE__), '..', 'templates', '/right_api_client.yml.erb')
      @config = RightScaleCLI::Config.new.local
    end

    no_commands{
    def update_conf(directives)
      renderer = ERB.new(IO.read(@conf_template_path))
      File.open(local_filename, 'w') {|f| f.write(renderer.result(binding)) }
    end
    }

    desc "account", "Configure the RightScale account ID for the client."
    def account()
      account = ask("RightScale account ID (e.g. 1337):") 
    end

    desc "user", "Configure the RightScale user for the client."
    def user()
      email = ask("RightScale username (e.g. bill.gates@microsoft.com):")
    end

    desc "password", "Configure the RightScale user password for the client."
    def password()
      password = ask_pass.strip
    end

    desc "api", "Configure the RightScale API version used by the client."
    def api()
      api_version = ask("RightScale API version (e.g. 1.5):")
    end

    desc "shard", "Configure the RightScale shard used by the client."
    def shard()
      api_url = "https://#{ask("RightScale shard (e.g. us-4.rightscale.com):")}"
    end

    desc "show", "Print the current configuration from ~/.rightscale/right_api_client.yml."
    def show()
      puts @config
    end

    desc "all", "Configure RightScale CLI."
    def all()
      directives = {
        :account_id => account(),
        :email => user(),
        :password_base64 => Base64.encode64(ask_pass).strip,
        :api_url => shard(),
        :api_version => api()
      }
      @logger.debug(directives)

      update_conf(directives)

      puts 'Configuration updated.'
    end

    #default_task :all

    def self.banner(task, namespace = true, subcommand = false)
      "#{basename} #{task.formatted_usage(self, true, subcommand)}"
    end
  end
end
