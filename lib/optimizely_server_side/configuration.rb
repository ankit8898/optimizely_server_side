# frozen_string_literal: true
module OptimizelyServerSide

  class Configuration

    # Configuration enables to open up the configuration of gem for the application.
    # config_endpoint: Optimizely config endpoint
    # cache_expiry: (In minutes) How long we want to cache the config.
    attr_accessor :config_endpoint, :cache_expiry, :user_attributes, :logger,
      :event_dispatcher

    def initialize
      @config_endpoint  = 'http://foo.com'
      @cache_expiry     = 15
      @user_attributes  = {}
    end

  end
end
