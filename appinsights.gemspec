Gem::Specification.new do |s|
  s.name        = 'appinsights'
  s.version     = '0.0.1'
  s.date        = Time.now.strftime('%Y-%m-%d')
  s.summary     = 'Application Insights Auto-Installer'
  s.description = 'Application Insights AutoInstaller for Ruby'
  s.authors     = ['Emiliano Mancuso']
  s.email       = ['emiliano.mancuso@gmail.com']
  s.homepage    = 'http://github.com/citrusbyte/appinsights'
  s.license     = 'MIT'

  s.files = Dir[
    'README.md',
    'Rakefile',
    'lib/**/*.rb',
    '*.gemspec',
    'test/*.*'
  ]

  s.add_dependency 'toml-rb', '~> 0.2.1'
  s.add_dependency 'application_insights', '~> 0.5.0'

  s.add_development_dependency 'rack', '~> 1.6', '>= 1.6.0'
end
