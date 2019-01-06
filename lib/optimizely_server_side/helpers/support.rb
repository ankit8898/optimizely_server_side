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
      variation_key = optimizely_sdk_project_instance(experiment_key, "experiment")
      OptimizelyServerSide::Experiment.new(experiment_key, variation_key).start(&blk)
    end
    alias_method :feature_flip, :experiment

    def optimizely_sdk_project_instance(experiment_key, type)
      case type
      when "experiment"
        get_optimizely_instance.activate(experiment_key, visitor_id, user_attributes)
      when "feature"
        get_optimizely_instance.is_feature_enabled(experiment_key, visitor_id, user_attributes)
      end  
    end

    def feature_test(experiment_key, options = {})
      OptimizelyServerSide.configuration.user_attributes.merge!(options.stringify_keys)
      optimizely_sdk_project_instance(experiment_key, "feature")
    end
    
    [:string, :boolean, :integer, :double].each do |type|
      define_method :"get_feature_variable_#{type}" do |experiment, variable_name |
        method = get_optimizely_instance.method("get_feature_variable_#{type}")
        method.call(experiment, variable_name, visitor_id )
      end
    end

    def visitor_id
      OptimizelyServerSide.configuration.user_attributes['visitor_id']
    end

    def user_attributes
      OptimizelyServerSide.configuration.user_attributes.reject { |k,v| k == 'visitor_id'}
    end

    def get_optimizely_instance
      OptimizelyServerSide::OptimizelySdk
      .project_instance(event_dispatcher: OptimizelyServerSide.configuration.event_dispatcher)
    end

  end
end
