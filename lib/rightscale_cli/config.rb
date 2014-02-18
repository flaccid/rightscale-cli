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

require 'yaml'
require 'fileutils'

class RightScaleCLI
  class Config
    attr_accessor :template_path, :config_home, :config_path, :directives

    def initialize(*args)
      @template_path = File.join(File.dirname(__FILE__), '..', 'templates', 'right_api_client.yml.erb')
      @config_home = File.join(ENV['HOME'], '.rightscale')
      @config_path = File.join(@config_home, 'right_api_client.yml')

      Dir.mkdir(@config_home) unless File.exists?(@config_home)
      FileUtils.touch(@config_path)
      
      # write a fresh file if it does not load/parse
      unless YAML.load_file(@config_path)
        @directives = {
           :account_id => '',
           :email => '',
           :password_base64 => '',
           :api_url => 'https://us-4.rightscale.com',
           :api_version => '1.5'
        }
        File.open(@config_path, 'w') {|f| f.write(ERB.new(IO.read(@template_path)).result(binding)) }
      end

      # load/reload the directives from the file
      @directives = YAML.load_file(@config_path)
    end
  end
end
