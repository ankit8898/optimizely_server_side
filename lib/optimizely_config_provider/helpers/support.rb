module OptimizelyConfigProvider

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
      variation_instance   = OptimizelyConfigProvider::Variation.new(result_variation_key)
      blk.call(variation_instance)
      variation_instance.compute
    end

    def optimizely_sdk_project_instance(experiment_key)
      OptimizelyConfigProvider::OptimizelySdk.project_instance(event_dispather: MyEventDispatcher.new).activate(experiment_key, OptimizelyConfigProvider.configuration.visitor_id)
    end

  end
end
