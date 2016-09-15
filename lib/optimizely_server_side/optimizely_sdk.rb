# frozen_string_literal: true
module OptimizelyServerSide

  class OptimizelySdk

    class << self

      # Public method to be accessed in the application
      # This is the project instance and is giving
      # access to all the optimizely sdk methods.
      # Datafile
      def project_instance(options = {})
        Optimizely::Project.new(cached_datafile,
                                options[:event_dispatcher],
                                nil,
                                nil,
                                true #skip_json_validation
                                )
      end

      def cached_datafile
        Cache.fetch('optimizely_sdk_config') do
          DatafileFetcher.datafile.content
        end
      end

    end

  end
end
