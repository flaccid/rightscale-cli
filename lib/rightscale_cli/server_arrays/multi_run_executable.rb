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

class RightScaleCLI
  class ServerArrays < Thor
  
    desc "run_exec", "Runs a RightScript or Chef recipe on the array instances."

    def run_exec(server_array_id, exec_type, exec_identifier)
      params = {}

      if exec_type == 'recipe'
        params['recipe_name'] = exec_identifier
      elsif exec_type == 'rightscript'
        params['right_script_href'] = "/api/right_scripts/#{exec_identifier}"
      end
      
      server_array = @client.client.server_arrays(:id => server_array_id)

      @logger.info "params: #{params}" if options[:debug]
      @logger.info "Running executable on server array."

      server_array.multi_run_executable(params)
    end
  end
end
