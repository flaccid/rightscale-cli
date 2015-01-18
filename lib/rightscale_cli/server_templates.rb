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
require 'json'
require 'active_support/core_ext/object/blank'
require 'rightscale_cli/logger'
require 'rightscale_cli/client'

class RightScaleCLI
  class ServerTemplates < Thor
    namespace :server_templates

    def initialize(*args)
      super
      @client = RightScaleCLI::Client.new(options)
      @logger = RightScaleCLI::Logger.new()
    end

    # include render options
    eval(IO.read("#{File.dirname(File.expand_path(__FILE__))}/render_options.rb"), binding)
    
    desc "list", "Lists ServerTemplates."
    def list()
      @client.render(@client.get('server_templates'), 'server_templates')
    end
    
    desc "show", "Shows a ServerTemplate."
    def show(server_template_id)
      @client.render(@client.show('server_templates', server_template_id), 'server_template')
    end

    desc "inputs", "Shows a ServerTemplate's inputs."
    def inputs(server_template_id)
      server_template_inputs = []
      @client.client.server_templates(:id => server_template_id).show.inputs.index.each do |input|
        server_template_inputs.push(input.raw)
      end
      @client.render(server_template_inputs, 'inputs')
    end
    
    desc "inputs_dashboard", "Inputs scraped from dashboard."
    def inputs_dashboard(server_template_id)
      uri = URI.parse("#{@client.client.api_url}/acct/#{@client.client.account_id}/inputs/edit_inputs?container_id=#{server_template_id}&container_type=ServerTemplate")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Get.new(uri.request_uri)
      request.add_field("Referer", "#{@client.client.api_url}/acct/#{@client.client.account_id}/server_templates/#{server_template_id}")
      request.add_field("X-Requested-With", "XMLHttpRequest")
      request.add_field("Cookie", @client.client.last_request[:request].headers[:cookie])
      response = http.request(request)
      puts response.body if options[:debug]

      require 'nokogiri'
      inputs = []
      html = Nokogiri::HTML(response.body)
      input_list = html.css('ul[class=inputList]').css('li[class=inputContainer]').css('div[class=inputInformation]').each { |input_html|
        input = {}
        input['name'] = input_html.css('div')[0].text.gsub!(/\s+/, "")
        input['possible_values'] = []
        input_html.css('div[class=inputValue]').css('select[class=possible_values] option').each { |option|
          input['current'] = option['value'] if option['selected'] == 'selected'
          input['possible_values'].push(option['value'])
        }
        inputs.push(input)
      }

      @client.render(inputs, 'inputs')
    end
  end
end
