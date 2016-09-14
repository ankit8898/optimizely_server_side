# frozen_string_literal: true

require 'active_support/core_ext/string/output_safety'

module OptimizelyServerSide
  class Experiment

    def initialize(experiment_key, selected_variation_key)
      @selected_variation_key = selected_variation_key
      @experiment_key         = experiment_key
      @variations             = []
    end

    # Hidden omniture tag for HTML tracking
    def omniture_tag(evar: nil)
      if @selected_variation_key
        "<input type='hidden' data-optimizely=#{@experiment_key}:#{@selected_variation_key} data-optimizely-evar=#{evar}></input>".html_safe
      end
    end

    # Starts the experiment
    def start
      yield(self)
      self.applicable_variation
    end

    def variation_one(key, opts = {}, &blk)
      add_variation(key, opts, &blk)
    end

    def variation_two(key, opts = {}, &blk)
      add_variation(key, opts, &blk)
    end

    def variation_default(key, opts = {}, &blk)
      add_variation(key, opts, &blk)
    end

    # Support for variation_three, variation_four till variation_n
    def method_missing(key, *args, &blk)
      if key.to_s.match('variation_')
        add_variation(args[0], args[1] || {}, &blk)
      else
        super
      end
    end

    # Selects and calls the variation which is applicable
    # In case of running test the applicable variation key is present
    # In case of fallback / paused test we pick the primary variation
    def applicable_variation
      ActiveSupport::Notifications.instrument "oss.variation", variation: @selected_variation_key, experiment: @experiment_key, visitor_id: OptimizelyServerSide.configuration.user_attributes['visitor_id'] do
        if @variations.any?(&variation_selector)
          @variations.find(&variation_selector).call
        else
          primary_variation.call if primary_variation
        end
      end
    end

    # Primary variation is where primary: true
    def primary_variation
      @primary_variation ||= @variations.find(&:primary)
    end

    private

    # Scope to query on selected variation
    def variation_selector
      ->(variation) { variation.key == @selected_variation_key }
    end

    # Add all the variation to the variations collection
    def add_variation(key, opts = {}, &blk)
      Variation.new(
        key: key,
        primary: opts[:primary] || false,
        content: blk
      ).tap do |variation_instance|
        @variations << variation_instance
      end
    end

  end
end
