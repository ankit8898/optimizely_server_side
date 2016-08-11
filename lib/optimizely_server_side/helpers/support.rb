module OptimizelyServerSide

  module Support

    # Enables for us to wrap experiments
    # Usage:
    # experiment('sign_up_test') do |config|
    #
    #   config.variation_one('variation_one_key') do
    #     # Code related to variation one
    #   end
    #
    #   config.variation_two('variation_two_key') do
    #     # Code related to variation two
    #   end
    #
    #   config.variation_default('variation_default_key') do
    #     # We still want to keep our default experience
    #   end
    #
    # end

    def experiment(experiment_key, &blk)
      result_variation_key = optimizely_sdk_project_instance(experiment_key)
      variation_instance   = OptimizelyServerSide::Variation.new(result_variation_key)
      blk.call(variation_instance)
      variation_instance.compute
    end

    def optimizely_sdk_project_instance(experiment_key)
      OptimizelyServerSide::OptimizelySdk
        .project_instance(event_dispatcher: MyEventDispatcher.new)
        .activate(experiment_key, OptimizelyServerSide.configuration.visitor_id)
    end

  end
end
