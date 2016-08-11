## Optimizely Server Side

[![Code Climate](https://codeclimate.com/github/ankit8898/optimizely_config_provider/badges/gpa.svg)](https://codeclimate.com/github/ankit8898/optimizely_config_provider) [![Build Status](https://travis-ci.org/ankit8898/optimizely_server_side.svg?branch=master)](https://travis-ci.org/ankit8898/optimizely_server_side)
[![Gem Version](https://badge.fury.io/rb/optimizely_server_side.svg)](https://badge.fury.io/rb/optimizely_server_side)
[![Test Coverage](https://codeclimate.com/github/ankit8898/optimizely_config_provider/badges/coverage.svg)](https://codeclimate.com/github/ankit8898/optimizely_config_provider/coverage)

### What is Optimizely Server Side ?

This is a wrapper on top of [Optimizely's](https://app.optimizely.com/projects) ruby sdk called [optimizely-sdk](https://github.com/optimizely/ruby-sdk) . The sdk specializes in server side setup of A/B test . You can read more about it [here](http://developers.optimizely.com/server/introduction/index.html) .

### If we have original sdk why need this wrapper ?

This gem solves few things:

 - **Syncing AB test config across different servers when you don't want to fetch config via REST endpoint or redis/memcache store**

  If you are using Optimizely you will be aware about the [datafile](http://developers.optimizely.com/server/reference/index.html#datafile). Once we make changes to the A/B test like change in percent distribution, start / pause a experiment this file get's updated.

  If you have 50 servers with 40 passenger / puma process these process needs to be updated.  The Gem polls the config at regular interval and keeps the file cached across different process.

  The config is stored in **Memory Store** .

* **Some additional helpers**

  Some more helpers exposed that can be exposed in views (.erbs) or PORO's.  It avoids duplication of few activation settings.


### Architecture

![alt text](https://github.com/ankit8898/optimizely_server_side/blob/master/docs/general_architecture.png
 "Architecture")

### Getting Started

Add the gem in you Gemfile

```ruby
 gem 'optimizely_server_side'
```

and

```ruby
bundle install
```

Add an initializer in `config/initializers/optimizely_server_side.rb`

```ruby
#config/initializers/optimizely_server_side.rb
OptimizelyServerSide.configure do |config|
  config.config_endpoint = 'https://cdn.optimizely.com/json/PROJECT_ID.json'
  config.cache_expiry    = 15 #(this is in minutes)
end

```
`PROJECT_ID` is a id of your  server side project at https://app.optimizely.com .


Optimizely needs a visitor_id to track the unique user and server a constant experience.  

In your Application controller

```ruby
class ApplicationController < ActionController::Base
  include OptimizelyServerSide::Support

  before_action :set_visitor_id

  def set_visitor_id
    cookies.permanent[:visitor_id] = '1234567' #some visitor_id

    # This links the browser cookie for visitor_id to
    # OptimizelyServerSide
    OptimizelyServerSide.configure do |config|  
        config.visitor_id = cookies[:visitor_id]
    end
  end

```


Now in your views or models


```ruby
experiment(EXPERIMENT_KEY) do |config|

  config.variation_one(VARIATION_ONE_KEY) do
    # Code for experience one. it can be html or a ruby code
  end

  config.variation_two(VARIATION_TWO_KEY) do
    # Code for experience two. it can be html or a ruby code
  end

  config.variation_default(VARIATION_DEFAULT_KEY) do
    # Code for experience default. it can be html or a ruby code
  end

end
```

EXPERIMENT_KEY: The experiment key that you will be getting while setting up your experiment from https://app.optimizely.com.

VARIATION_ONE_KEY: Key for Variation one. This will be also set when setting up experiment

VARIATION_TWO_KEY: Key for Variation two. This will be also set when setting up experiment

VARIATION_DEFAULT_KEY: Key for default experience. This will be also set when setting up experiment

![alt text](https://github.com/ankit8898/optimizely_server_side/blob/master/docs/screenshot.png "Logo Title Text 1")
