module OptimizelyServerSide

  # Maintains the API config response in Memory store cache.
  # user Activesupport MemoryStore store.
  class Cache

    include Singleton

    attr_reader :cache_store_instance

    # We are sticking with Activesupprt memory store as gem is to be used with
    # Rails app for now.
    def initialize
      @cache_store_instance = ActiveSupport::Cache::MemoryStore.new(
        expires_in: OptimizelyServerSide.configuration.cache_expiry.send(:minutes)
      )
    end

    class << self

      # fetch is a wrapper on top of Activesupport Fetch to set/get the
      # response via singleton instance
      def fetch(key)
        instance.cache_store_instance.fetch(key) { yield }
      end

    end
  end

end
