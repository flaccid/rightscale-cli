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
  class Output
    def self.render(content, root_element, options)
     if options[:xml]
        require "active_support/core_ext"
        puts content.to_xml(:root => root_element)
      elsif options[:json]
        require 'json'
        puts JSON.pretty_generate(content)
      else
        require 'yaml'
        puts content.to_yaml
      end
    end
  end
end
