module OptimizelyConfigProvider

  class Fetcher
    # Responsible for fetching the optimizely sdk config from
    # the API source. The API can be optimizely cdn itself or
    # any other source.
    API_URL = 'https://cdn.optimizely.com/json/5960232316.json'.freeze


    class << self

      # Fetch the Config from the specified source.
      def fetch
        Net::HTTP.get(URI(API_URL))
      end

      def parsed_response
        JSON.parse(fetch, symbolize_names: true)
      end

    end

  end
end
