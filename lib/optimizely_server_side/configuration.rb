# frozen_string_literal: true
module OptimizelyServerSide

  class Configuration

    # Configuration enables to open up the configuration of gem for the application.
    # config_endpoint: Optimizely config endpoint
    # cache_expiry: (In minutes) How long we want to cache the config.
    attr_accessor :config_endpoint, :cache_expiry, :visitor_id, :logger

    def initialize
      @config_endpoint  = 'http://foo.com'
      @cache_expiry     = 15
    end

  end
end
