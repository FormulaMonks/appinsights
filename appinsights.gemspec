require_relative 'lib/appinsights/version'

Gem::Specification.new do |s|
  s.name        = 'appinsights'
  s.version     = AppInsights::VERSION
  s.date        = Time.now.strftime('%Y-%m-%d')
  s.summary     = 'Application Insights Auto-Installer'
  s.description = 'Application Insights AutoInstaller for Ruby'
  s.authors     = ['Emiliano Mancuso']
  s.email       = ['emiliano.mancuso@gmail.com']
  s.homepage    = 'http://github.com/Theorem/appinsights'
  s.license     = 'MIT'

  s.files = Dir[
    'README.md',
    'Rakefile',
    'lib/**/*.rb',
    '*.gemspec',
    'test/*.*'
  ]

  s.add_dependency 'toml-rb', '~> 0.3.0'
  s.add_dependency 'application_insights', '~> 0.5.0'

  s.add_development_dependency 'rack', '~> 1.6'
end
