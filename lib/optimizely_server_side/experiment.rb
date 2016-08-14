module OptimizelyServerSide
  class Experiment

    def initialize(key)
      @another_key = key
      @store = {}
    end

    def start
      yield(self)
      self.compute
    end

    def variation_one(key, &blk)
      @store[key] = blk
    end

    def variation_two(key, &blk)
      @store[key] = blk
    end

    def variation_three(key, &blk)
      @store[key] = blk
    end

    def variation_default(key, &blk)
      @store[key] = blk
    end

    def compute
      ActiveSupport::Notifications.instrument "variation.variation", variation: @another_key do
        if @store[@another_key]
          @store[@another_key].call
        end
      end
    end

  end
end
