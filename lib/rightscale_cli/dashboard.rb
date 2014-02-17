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
require "net/https"
require "uri"
require 'rightscale_cli/logger'
require 'rightscale_cli/client'

class RightScaleCLI
  class Dashboard < Thor
    namespace :dashboard

    def initialize(*args)
      super
      @client = RightScaleCLI::Client.new(options)
      @logger = RightScaleCLI::Logger.new()
    end

    desc "overview", "RightScale Dashboard Overview."
    def overview()
      uri = URI.parse("#{@client.client.api_url}/acct/#{@client.client.account_id}/dashboard;overview")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Get.new(uri.request_uri)
      request.add_field("Cookie", @client.client.last_request[:request].headers[:cookie])

      response = http.request(request)
      puts response.body
    end

    desc "scrape", "Scrape a dashboard URL by href."
    def scrape(href)
      uri = URI.parse("#{@client.client.api_url}#{href}")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Get.new(uri.request_uri)
      request.add_field("Cookie", @client.client.last_request[:request].headers[:cookie])

      response = http.request(request)
      puts response.body
    end

    desc "ajax", "Scrape a dashboard URL via AJAX."
    def ajax(href)
      uri = URI.parse("#{@client.client.api_url}#{href}")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Get.new(uri.request_uri)
      request.add_field("Cookie", @client.client.last_request[:request].headers[:cookie])
      request.add_field("X-Requested-With", "XMLHttpRequest")

      response = http.request(request)
      puts response.body
    end
    
    def self.banner(task, namespace = true, subcommand = false)
      "#{basename} #{task.formatted_usage(self, true, subcommand)}"
    end
  end
end
