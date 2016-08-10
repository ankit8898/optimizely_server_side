module OptimizelyConfigProvider

  class DatafileFetcher
    # Responsible for fetching the optimizely sdk config from
    # the API source. The API can be optimizely cdn itself or
    # any other source.

    class << self

      # Fetch the Config from the specified source.
      def fetch
        Net::HTTP.get(URI(OptimizelyConfigProvider.configuration.config_endpoint))
      end
      alias_method :datafile, :fetch

    end

  end
end
