## Optimizely Server Side

[![Code Climate](https://codeclimate.com/github/ankit8898/optimizely_config_provider/badges/gpa.svg)](https://codeclimate.com/github/ankit8898/optimizely_config_provider) [![Build Status](https://travis-ci.org/ankit8898/optimizely_server_side.svg?branch=master)](https://travis-ci.org/ankit8898/optimizely_server_side)
[![Gem Version](https://badge.fury.io/rb/optimizely_server_side.svg)](https://badge.fury.io/rb/optimizely_server_side)
[![Test Coverage](https://codeclimate.com/github/ankit8898/optimizely_config_provider/badges/coverage.svg)](https://codeclimate.com/github/ankit8898/optimizely_config_provider/coverage)

### What is Optimizely Server Side ?

This is a wrapper on top of [Optimizely's](https://app.optimizely.com/projects) ruby sdk called [optimizely-sdk](https://github.com/optimizely/ruby-sdk) . The sdk specializes in server side setup of A/B test . You can read more about it [here](http://developers.optimizely.com/server/introduction/index.html) .

### If we have original sdk why need this wrapper ?

This gem solves few things:

 - **Syncing A/B test config across different servers when you don't want to fetch config via REST endpoint or redis/memcache store**

  Yes, it's designed keeping performance in mind as we want to save a network overhead and a extra dependency.

  If you are using Optimizely you will be aware about the [datafile](http://developers.optimizely.com/server/reference/index.html#datafile). Once we make changes to the A/B test like change in percent distribution, start / pause a experiment this file get's updated.

  If you have 50 servers with 40 passenger / puma process each these process needs to be updated.  The Gem polls the config at regular interval and keeps the datafile cached across different process.

  The config is stored in **Memory Store** . We use [Activesupport memory store](http://api.rubyonrails.org/classes/ActiveSupport/Cache/MemoryStore.html) for same.

* **Helper methods to better handle test and variations and handling fallbacks and experiment pause**

  Optimizely ruby sdk provides us way to know which variation to show. But what happens when the experiment is paused ? Or there is a error happening in config.  
  More details about this in below section of experiment config.

### Architecture

![alt Architecture](https://github.com/ankit8898/optimizely_server_side/blob/master/docs/general_architecture.png
 "Architecture")

### Getting Started

Add the gem in your Gemfile

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
  config.config_endpoint  = 'https://cdn.optimizely.com/json/PROJECT_ID.json'
  config.cache_expiry     = 15 #(this is in minutes)
  config.event_dispatcher = MyEventDispatcher.new
end

```

_Config info_

- `config_endpoint` - This is the Datafile endpoint which returns JSON config. `PROJECT_ID` is a id of your  server side project at https://app.optimizely.com .
- `cache_expiry` - Time we want to keep the config cached in memory.
- `event_dispatcher` - Optimizely needs to track every visit. You can pass your own event dispatcher from here. Read [more](https://developers.optimizely.com/server/reference/index#event-dispatcher)




Optimizely needs a `visitor_id` to track the unique user and server a constant experience.  

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

### Example usage

#### In your html.erb

```ruby
# in any app/view/foo.html.erb
<% experiment(EXPERIMENT_KEY) do |config| %>

  <% config.variation_one(VARIATION_ONE_KEY) do %>
    <%= render partial: 'variation_one_experience' %> 
  <% end %>

  <% config.variation_default(VARIATION_DEFAULT_KEY, primary: true) do %>
    <%= render partial: 'variation_default_experience' %>
  <% end %>
  
<% end %>
```

#### In your model or any PORO

```ruby
class Foo

  include OptimizelyServerSide::Support


  # This method is responsible from getting data from
  # any other rest endpoint.
  # Suppose you are doing a AB test on a new endpoint / data source.
  def get_me_some_data
    data = experiment(EXPERIMENT_KEY) do |config|

      config.variation_one(VARIATION_ONE_KEY) do
        HTTParty.get('http://from_source_a.com/users')
      end

      config.variation_default(VARIATION_TWO_KEY, primary: true) do
        HTTParty.get('http://from_source_b.com/users')
      end
    end

  end
end
```
#### Don't want to stick with variation_one, variation_two ?

You can call you own method names with `variation_` . Below i have `config.variation_best_experience` and `config.variation_pathetic_experience`.


```ruby
# in any app/view/foo.html.erb
<% experiment(EXPERIMENT_KEY) do |config| %>

  <% config.variation_best_experience(VARIATION_ONE_KEY) do %>
    <%= render partial: 'variation_one_experience' %>
  <% end %>

  <% config.variation_pathetic_experience(VARIATION_DEFAULT_KEY, primary: true) do %>
    <%= render partial: 'variation_default_experience' %>
  <% end %>
  
<% end %>

```
In the above examples:

`EXPERIMENT_KEY`: When you will set your experiment this key will be set up that time at https://app.optimizely.com.

`VARIATION_ONE_KEY`: Key for Variation one. This will be also set when setting up experiment.

`VARIATION_TWO_KEY`: Key for Variation two. This will be also set when setting up experiment.

`VARIATION_DEFAULT_KEY`: Key for default experience. This will be also set when setting up experiment

`primary: true` : If you see above some variations are marked with `primary: true`. This enables handling the fallback capabilities of optimizely_server_side. If there is any error pulling datafile or experiment is paused the `primary` experience is served.  Not setting primary won't give any experience during fallback times.  We encourage setting it up.

![alt Optimizely dashboard](https://github.com/ankit8898/optimizely_server_side/blob/master/docs/screenshot.png "Optimizely dashboard")


### Instrumentation

This is a trial feature and may or maynot exist in future version.

We have [ActiveSupport::Notifications](http://api.rubyonrails.org/classes/ActiveSupport/Notifications.html) hooked up for few places which are worth monitoring.


* When the datafile is fetched from cdn. In your application you can subscribe via below. This helps to monitor the time it takes from CDN fetch

```ruby
ActiveSupport::Notifications.subscribe "oss.call_optimizely_cdn" do |name, started, finished, unique_id, data|
  Rails.logger.info "GET Datafile from Optimizely CDN in #{(finished - started) * 1000} ms"
end
```
* Which variation is being served currently. In your application you can subscribe via below

```ruby

ActiveSupport::Notifications.subscribe "oss.variation" do |name, started, finished, unique_id, data|
  Rails.logger.info "GET Variation from OSS in #{(finished - started) * 1000} ms with variation key #{data[:variation]}"
end
```
### Testing

Gem uses rspec for unit testing

```ruby
$~/D/p/w/optimizely_server_side> rspec .
......................................................

Finished in 0.12234 seconds (files took 0.5512 seconds to load)
54 examples, 0 failures

```

### License

The MIT License
