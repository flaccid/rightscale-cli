# Author:: Chris Fordham (<chris@fordham-nagy.id.au>)
# Copyright:: Copyright (c) 2013-2015 Chris Fordham
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
require 'rightscale_cli/logger'
require 'rightscale_cli/client'
require 'rightscale_cli/config'
require 'net/https'
require 'uri'

class RightScaleCLI
  # Represents an API token refresh
  class Refresh < Thor
    # namespace :volumes

    def initialize(*args)
      super
      # @client = RightScaleCLI::Client.new(options)
      @logger = RightScaleCLI::Logger.new
      @config = RightScaleCLI::Config.new.directives
    end

    desc 'token', 'refresh the api token' \
      'description, name, parent volume snapshot or resource UID (default)'
    def token
      token_endpoint = @config[:token_endpoint]
      refresh_token = @config[:refresh_token]
      puts refresh_token
      puts token_endpoint
      uri = URI.parse(token_endpoint)
      https = Net::HTTP.new(uri.host, uri.port)
      https.set_debug_output($stdout)
      https.use_ssl = true
      request = Net::HTTP::Post.new(uri.path)
      request['X-API-Version'] = '1.5'
      request.set_form_data(grant_type: 'refresh_token',
                            refresh_token: refresh_token)
      response = https.request(request)
      puts response.body
    end

    def self.banner(task, _namespace = true, subcommand = false)
      "#{basename} #{task.formatted_usage(self, true, subcommand)}"
    end
  end
end
