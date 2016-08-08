module OptimizelyConfigProvider
  class OptimizelySdk

    include Singleton

    def self.data
      instance.data
    end

    #    private

    def data
      Cache.fetch('optimizely_sdk_config') do
        puts "===I am getting Fresh Config!==="
        Optimizely::Project.new(Fetcher.parsed_response)
      end
    end

  end
end
