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
require 'right_api_client'

class RightScaleCLI
  class Repositories < Thor
    namespace :repositories

    desc "list", "Lists all (Chef) Repositories."
    def list()
      repositories = []
      RightApi::Client.new(RightScaleCLI::Config::API).repositories.index.each { |repos| repositories.push(repos.raw) }  
      RightScaleCLI::Output.render(repositories, 'repositories', options)
    end

    desc "create", "Creates a (Chef) Repository."
    def create(name, source, source_ref)
      # create profile of the repository to add
      # http://reference.rightscale.com/api1.5/resources/ResourceRepositories.html#create
      repository = {}
      repository['source_type'] = 'git'     # only git supported so far
      repository['auto_import'] = true
      repository['source'] = source
    
      # not yet supported by CLI
      repository['credentials'] = {}
      repository['credentials']['ssh_key'] = 'text:'    # needed due to bad validation

      repository['name'] = "#{name}"
      repository['commit_reference'] = source_ref
      repository['description'] = ""      # todo

      puts repository if options[:verbose]

      $log.info "Creating RightScale repository, '#{repository['name']}'."
      repo = RightApi::Client.new(RightScaleCLI::Config::API).repositories.create({ :repository => repository })
    end

    desc "destroy", "Deletes a (Chef) Repository."
    def destroy(id)
      RightApi::Client.new(RightScaleCLI::Config::API).repositories.index(:id => id).destroy
    end

    def self.banner(task, namespace = true, subcommand = false)
      "#{basename} #{task.formatted_usage(self, true, subcommand)}"
    end
  end
end
