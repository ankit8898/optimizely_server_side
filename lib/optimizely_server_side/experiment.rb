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
      puts "---Experience selected----- #{@another_key}"
      if @store[@another_key]
        @store[@another_key].call
      end
    end

  end
end
#
# a = Foo.new.start do |config|
#
#   config.game_one('aa') do
#     '<div>       \n   </div>'
#   end
#
#   config.game_two('bb') do
#     '<div>       \n kjsdkaskfsajkfjk   </div>'
#   end
# end
#
# p a
