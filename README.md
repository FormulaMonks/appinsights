# appinsights
[![Gem Version](https://badge.fury.io/rb/appinsights.svg)](http://badge.fury.io/rb/appinsights)
[![Build Status](https://travis-ci.org/Theorem/appinsights.svg)](https://travis-ci.org/Theorem/appinsights)
[![Code Climate](https://codeclimate.com/github/citrusbyte/appinsights/badges/gpa.svg)](https://codeclimate.com/github/citrusbyte/appinsights)

Microsoft Application Insights Auto Installer for Ruby frameworks

## Dependencies

`appinsights` requires:

- Ruby 2.0 or later
- `application_insights` to connect with Microsoft Application Insights
- `toml-rb` to read the config file

Install dependencies using `dep` is easy as run:

    $ dep install

# Installation

Install the latest release using `gem`

    $ gem install appinsights

Or just add `gem 'appinsights'` in your _Gemfile_ and then run:

    $ bundle install

## Automatic

This is the recommended installation and it will be automatically fired if your
application uses one of the supported frameworks:

- Rails
- Sinatra

In case the _automatic installation_ is not available (non-supported framework,
missing config file, etc.) you can always install the Application Insights Instruments
using the _Manual_ installation


### Rails

`rails` automatically loads the gem if it is listed on the _Gemfile_.
There is nothing else to do.

### Sinatra

`sinatra`, like other `rack` based frameworks, needs to require the library.

Add the following line in your _sinatra application file_:

```ruby
require 'appinsights'
```

> NOTE: Ensure that `sinatra` was required first.

### Cuba

`cuba` is similar to `sinatra` but it requires one more line to configure it.
Since a `cuba` application does not keep the root path of the application we
have to specify it to read the config file and complete the installation.
Given this is a common framework, there is a one-step-installation line:

```ruby
require 'appinsights'

# Accepts the root path of the application and an optional file name
AppInsights::CubaInstaller.init File.dirname(__FILE__)
```

## Manual

Choosing a _Manual_ configuration is for those who have an application using a
non-supported framework or the ones who wants to have total control of the application.

The only requisite for your _application_ is to support usage of `rack` middlewares.

```ruby
require 'appinsights'

# app - Application where we will attach the middlewares
# root - Root directory of the application
# filename (optional) - Relative path of the config file
# logger (optional) - Logger object to log errors and info.

installer = AppInsights::BaseInstaller.new app, root, filename, logger

# Now you have an installer ready to be executed

installer.install

# This will load the configuration file and add the middlewares enabled on the
# config file.
```

In case you want to check the configs or which middlewares were enabled using
ruby code, here is some useful lines of code:

```ruby
# Check the Context settings.
Application::Context.context
=> #<ApplicationInsights::Channel::TelemetryContext:0x007f961dbf3b18 ...>


# Check the Middlewares settings
AppInsights::Middlewares.settings
=> [{"name"=>"AppInsights::ExceptionHandling", "enabled"=>true}, ... ]

# Check the Middlewares enabled
AppInsights::Middlewares.enabled
=> [[AppInsights::ExceptionHandling, {}], ... ]
```


# Configuration file

`appinsights` uses TOML, a minimal configuration file format that's easy to read.
If you are not familiar with TOML, please [read the specs][toml_specs].

## Structure

There are two big _structures_ inside the configuration file.

1. Application Insights Context settings
2. Middlewares

### 1. Application Insights Context settings

All this settings must be grouped by _'ai'_ table.
This settings are defined for every _contract_ on the [SDK][ai_sdk]

The only exception and the most important setting is the **instrumentation_key**
that must be defined under the _'ai'_ table.

Lets see an example:

```toml
[ai]
  instrumentation_key = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'
  custom = 4
  properties = 'belong to the context'

# Contracts configuration

  [ai.application]
    ver = '0.2.0'

  [ai.device]
    id = 'device001'
    os = 'OSX'

  [ai.user]
    id = 'a_user_id'
    accountId = '1234567890'
```

### 2. Middlewares

This is the other important structure on the configuration file.
Here we will define which middleware we want to use and enable or disable it.
We defined `appinsights` to be as flexible as possible, so we can configure
middlewares defined in other libraries but they were defined in our scope.

Of course that you can add extra parameters for your personal usage but
there are two required parameters for every _middleware_ definition:

- `name` - Complete constant name of the middleware
- `enabled` - boolean

And given there are some _middleware_ which needs extra parameters at the
initialization process, you can define a hash with the attributes and we will
preserve the order of the attributes defined.

If you are a little confused, here is a valid example for both scenarios:

```toml
[[middleware]]
  name = 'AppInsights::ExceptionHandling'
  enabled = true

[[middleware]]
  name = 'ApplicationInsights::Rack::TrackRequest'
  enabled = true

  [middleware.initialize]
    instrumentation_key = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'
    buffer_size = 250
    send_interval = 30
```

## Location

By default `appinsights` will search for the configuration file, starting at
the root of the project

- `./config/application_insights.toml`
- `./application_insights.toml`

You can also use a custom file name and path before start the application.
Set the environment variable `AI_CONFIG_RPATH` with the relative path of the file

    $ export AI_CONFIG_RPATH='./settings/appinsights_settings.toml'



[toml_specs]: https://github.com/toml-lang/toml/blob/master/versions/en/toml-v0.3.1.md
[ai_sdk]: https://github.com/Microsoft/AppInsights-Ruby/tree/master/lib/application_insights/channel/contracts
