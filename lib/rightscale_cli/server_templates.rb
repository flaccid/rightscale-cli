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
require "active_support/core_ext"
require 'rightscale_cli/logger'
require 'rightscale_cli/client'

class RightScaleCLI
  class ServerTemplates < Thor
    namespace :server_templates

    # include render options
    eval(IO.read("#{File.dirname(File.expand_path(__FILE__))}/render_options.rb"), binding)
    
    desc "list", "Lists ServerTemplates."
    def list()
      log = CLILogger.new
      rightscale = RightApi::Client.new(RightScaleCLI::Config::API)
      server_templates = []
      rightscale.server_templates.index.each { |server_template|
        server_templates.push(server_template.raw)
      }

      if options[:xml]
        puts server_templates.to_xml(:root => 'server_templates')
      elsif options[:json]
        puts JSON.pretty_generate(server_templates)
      else
        puts server_templates.to_yaml
      end
    end
    
    desc "show", "Shows a ServerTemplate."
    def show(server_template_id)
      log = CLILogger.new
      rightscale = RightApi::Client.new(RightScaleCLI::Config::API)

      server_template = rightscale.server_templates(:id => server_template_id).show.raw

      if options[:xml]
        puts server_template.to_xml(:root => 'server_template')
      elsif options[:json]
        puts JSON.pretty_generate(server_template)
      else
        puts server_template.to_yaml
      end
    end

    desc "inputs", "Shows a ServerTemplate's inputs."
    def inputs(server_template_id)
      log = CLILogger.new
      rightscale = RightApi::Client.new(RightScaleCLI::Config::API)

      server_template_inputs = []      
      rightscale.server_templates(:id => server_template_id).show.inputs.index.each { |input| server_template_inputs.push(input.raw) }

      if options[:xml]
        puts server_template_inputs.to_xml(:root => 'server_template')
      elsif options[:json]
        puts JSON.pretty_generate(server_template_inputs)
      else
        puts server_template_inputs.to_yaml
      end
    end
    
    desc "inputs_dashboard", "Inputs scraped from dashboard."
    def inputs_dashboard(server_template_id)
      rightscale = RightApi::Client.new(RightScaleCLI::Config::API)
      uri = URI.parse("#{rightscale.api_url}/acct/#{rightscale.account_id}/inputs/edit_inputs?container_id=#{server_template_id}&container_type=ServerTemplate")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Get.new(uri.request_uri)
      request.add_field("Referer", "#{rightscale.api_url}/acct/#{rightscale.account_id}/server_templates/#{server_template_id}")
      request.add_field("X-Requested-With", "XMLHttpRequest")
      request.add_field("Cookie", YAML.load_file(File.join(ENV['HOME'], '.rightscale', 'right_api_client.yml'))[:dashboard_cookies])
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
          input['default'] = option['value'] if option['selected'] == 'selected'
          input['possible_values'].push(option['value'])
        }
        inputs.push(input)
      }

      if options[:xml]
        puts inputs.to_xml(:root => 'inputs')
      elsif options[:json]
        puts JSON.pretty_generate(inputs)
      else
        puts inputs.to_yaml
      end
    end
  end
end
