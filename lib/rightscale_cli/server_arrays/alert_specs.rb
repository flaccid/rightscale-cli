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

    desc "alert_specs", "Shows a server array's alert specifications."

    def alert_specs(server_array_id)
      rightscale = RightApi::Client.new(RightScaleCLI::Config::API)

      alert_specs = []
      rightscale.server_arrays(:id => server_array_id).show.alert_specs.index.each { |alert_spec|
        alert_specs.push(alert_spec.raw)
      }

      if options[:xml]
        puts alert_specs.to_xml(:root => 'alert_specs')
      elsif options[:json]
        puts JSON.pretty_generate(alert_specs)
      else
        puts alert_specs.to_yaml
      end
    end
  end
end
