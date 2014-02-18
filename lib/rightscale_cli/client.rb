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

require 'right_api_client'
require 'rightscale_cli/config'
require 'rightscale_cli/logger'
require 'ask_pass'

class RightScaleCLI
  class Client
    attr_accessor :client
    attr_accessor :render
    
    def initialize(options)
      config = RightScaleCLI::Config.new.directives
      config[:account_id] = options['account'] if options[:account]
      config[:email] = options['user'] if options[:user]
      config[:api_version] = options['api'] if options[:api]

      if options['password'] || (!config[:password] && !config[:password_base64])
        config[:password] = ask_pass
        config[:password_base64] = nil    # set this to nil so it is not used by precedence
      end

      @options = options
      @client = RightApi::Client.new(config)
      @logger = RightScaleCLI::Logger.new()
    end

    def get(resource)
      result = []
      @client.send(resource).index.each { |record|
        result.push(record.raw)
      }
      return result
    end

    def show(resource, resource_id, *args)
      if args.count > 0
        result = []
        records = @client.send(resource).index({ :id => resource_id }).show.send(args[0]).index
        records.each { |record|
          result.push(record.raw)
        }
        @logger.info("Resource count: #{result.count}.")
      else
        result = @client.send(resource).index({ :id => resource_id }).show.raw
      end
      return result 
    end

    def create(resource, params)
      resource = @client.send("#{resource}s").create(resource => params)
      @logger.info("Created #{resource.href}.")
    end

    def destroy(resource, resource_id)
      resource = @client.send("#{resource}s").index({ :id => resource_id })
      resource.destroy
      @logger.info("Deleted #{resource.href}.")
    end

    def render(data, root_element)
      RightScaleCLI::Output.render(data, root_element, @options)
    end
  end
end
