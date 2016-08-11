# frozen_string_literal: true
module OptimizelyServerSide

  class DatafileFetcher
    # Responsible for fetching the optimizely sdk config from
    # the API source. The API can be optimizely cdn itself or
    # any other source.

    class << self

      # Fetch the Config from the specified source.
      def fetch
        response = Net::HTTP.get_response(URI(OptimizelyServerSide.configuration.config_endpoint))
        response.is_a?(Net::HTTPSuccess) ? response.body : ''
      end
      alias_method :datafile, :fetch

    end

  end
end
