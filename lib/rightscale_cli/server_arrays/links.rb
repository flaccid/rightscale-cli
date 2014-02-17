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

require 'rightscale_cli/client'
require 'rightscale_cli/logger'

class RightScaleCLI
  class ServerArrays < Thor

    def initialize(*args)
      super
      @client = RightScaleCLI::Client.new(options)
      @logger = RightScaleCLI::Logger.new()
    end
    
    desc "links", "Lists the links for a server array."

    def links(server_array_id)
      @logger.info "Retrieving links for server array, #{server_array_id}."
      @client.render(@client.client.server_arrays(:id => server_array_id).show.links, 'links')
    end
  end
end
