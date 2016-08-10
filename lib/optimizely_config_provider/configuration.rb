module OptimizelyConfigProvider

  class Configuration

    attr_accessor :config_endpoint, :expires_in

    def initialize
      @config_endpoint = 'http://foo.com'
    end
  end
end
