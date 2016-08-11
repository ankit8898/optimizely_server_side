module OptimizelyServerSide

  class OptimizelySdk

    # Public method to be accessed in the application
    # This is the project instance and is giving
    # access to all the optimizely sdk methods.
    # Datafile
    def self.project_instance(options = {})
      Cache.fetch('optimizely_sdk_config'.freeze) do
        puts "Getting the config"
        Optimizely::Project.new(DatafileFetcher.datafile, options[:event_dispatcher])
      end
    end

  end
end
