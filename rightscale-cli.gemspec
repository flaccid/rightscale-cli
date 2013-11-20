Gem::Specification.new do |s|
  s.name        = 'rightscale-cli'
  s.version     = '0.2.0'
  s.date        = '2013-11-21'
  s.summary     = "rightscale-cli"
  s.description = "RightScale command line interface client."
  s.authors     = ["Chris Fordham"]
  s.email       = 'chris@fordham-nagy.id.au'
  s.licenses    = ['Apache 2.0']
  s.files       = Dir['{bin,lib}/**/*', 'README*', 'LICENSE*'] 
  s.bindir      = 'bin'
  s.executables = Dir.entries(s.bindir) - [".", "..", '.gitignore']
  s.homepage    = 'https://github.com/flaccid/rightscale-cli'
  s.add_dependency 'activesupport'
  s.add_dependency "json", ">= 1.4.4"
  s.add_dependency 'right_api_client'
  s.add_dependency 'octokit'
  s.add_dependency 'thor'
  s.add_dependency 'nokogiri'
end
