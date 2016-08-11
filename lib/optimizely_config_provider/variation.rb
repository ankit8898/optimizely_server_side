module OptimizelyConfigProvider

  class Variation

    attr_reader :hsh

    def initialize(variation_key)
      @variation_key = variation_key
      @hsh = {}
    end

    # Variation one of experiment
    def variation_one(key)
      @hsh[key] = yield
    end

    # Variation two of experiment
    def variation_two(key)
      @hsh[key] = yield
    end

    def variation_default(key)
      @hsh[key] = yield
    end

    # Variation three of experiment
    def variation_three(key)
      @hsh[key] = yield
    end

    # Select which variation to be picked up
    def compute
      @hsh.select do |key,value|
        key == @variation_key
      end.values[0]
    end
  end
end
