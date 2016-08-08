module OptimizelyConfigProvider

  # Maintains the API config response in Memory store cache.
  # user Activesupport MemoryStore store.
  class Cache

    include Singleton

    attr_reader :cache_store_instance

    # We are sticking with Activesupprt memory store as gem is to be used with
    # Rails app for now.
    def initialize
      @cache_store_instance = ActiveSupport::Cache::MemoryStore.new(expires_in: 20.seconds)
    end

    class << self

      # fetch is a wrapper on top of Activesupport Fetch to set/get the
      # response via singleton instance
      def fetch(key)
        # instance.cache_store_instance.fetch('optimizely_config'.freeze) do
        #   Fetcher.parsed_response
        # end
        instance.cache_store_instance.fetch(key) { yield }

      end

    end
  end

end
