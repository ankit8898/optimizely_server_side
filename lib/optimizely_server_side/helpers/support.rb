# frozen_string_literal: true

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
    #   config.variation_default('variation_default_key', primary: true) do
    #     # We still want to keep our default experience
    #   end
    #
    # end
    def experiment(experiment_key, options = {}, &blk)
      # Merge any other options to user attributes
      OptimizelyServerSide.configuration.user_attributes.merge!(options.stringify_keys)
      variation_key = optimizely_sdk_project_instance(experiment_key)
      OptimizelyServerSide::Experiment.new(experiment_key, variation_key).start(&blk)
    end
    alias_method :feature_flip, :experiment

    def optimizely_sdk_project_instance(experiment_key)
      OptimizelyServerSide::OptimizelySdk
      .project_instance(event_dispatcher: OptimizelyServerSide.configuration.event_dispatcher)
      .activate(experiment_key,
                OptimizelyServerSide.configuration.user_attributes['visitor_id'],
                OptimizelyServerSide.configuration.user_attributes.reject { |k,v| k == 'visitor_id'})
    end

  end
end
