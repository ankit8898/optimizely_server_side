module OptimizelyServerSide
  class Experiment

    def initialize(key)
      @selected_variation_key = key
      @variations             = []
    end

    # Starts the experiment
    def start
      yield(self)
      self.applicable_variation
    end

    [
      :variation_one,
      :variation_two,
      :variation_three,
      :variation_default,
    ].each do |variation|
      define_method(variation) do |key, opts={}, &blk|  # def variation_one(key, opts = {}, &blk)
        add_variation(key, opts, &blk)                  #   add_variation(key, opts, &blk)
      end                                               # end
    end

    # Selects and calls the variation which is applicable
    # In case of running test the applicable variation key is present
    # In case of fallback / paused test we pick the primary variation
    def applicable_variation
      ActiveSupport::Notifications.instrument "oss.variation", variation: @another_key do
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
