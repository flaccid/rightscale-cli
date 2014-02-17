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
require 'rightscale_cli/logger'
require 'rightscale_cli/client'

class RightScaleCLI
  class Configure < Thor
    namespace :configure

    def initialize(*args)
      super
      @logger = RightScaleCLI::Logger.new()
    end

    desc "account", "Configure the RightScale account ID for the client."
    def account()

    end

    desc "user", "Configure the RightScale user for the client."
    def user()

    end

    desc "password", "Configure the RightScale user password for the client."
    def password()

    end
    
    def self.banner(task, namespace = true, subcommand = false)
      "#{basename} #{task.formatted_usage(self, true, subcommand)}"
    end
  end
end
