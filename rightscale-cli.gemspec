Gem::Specification.new do |s|
  s.name        = 'rightscale-cli'
  s.version     = '0.5.6'
  s.date        = '2014-02-18'
  s.summary     = 'rightscale-cli'
  s.description = 'RightScale command line interface client.'
  s.authors     = ['Chris Fordham']
  s.email       = 'chris@fordham-nagy.id.au'
  s.licenses    = ['Apache 2.0']
  s.files       = Dir['{bin,lib}/**/*', 'README*', 'LICENSE*']
  s.bindir      = 'bin'
  s.executables = Dir.entries(s.bindir) - ['.', '..', '.gitignore']
  s.homepage    = 'https://github.com/flaccid/rightscale-cli'
  s.add_runtime_dependency 'activesupport', '~> 4.0'
  s.add_runtime_dependency 'builder', '~> 3.0'
  s.add_runtime_dependency 'json', '~> 1.4', '>= 1.4.4'
  s.add_runtime_dependency 'right_api_client', '~> 1.5'
  s.add_runtime_dependency 'octokit', '~> 2.7'
  s.add_runtime_dependency 'thor', '~> 0.18'
  s.add_runtime_dependency 'nokogiri', '~> 1.6'
end
