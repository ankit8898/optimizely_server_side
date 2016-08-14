require "erb"
class Foo

  def initialize
    @another_key = 'bb'
    @hsh = {}
  end

  def start
    yield(self)
    self.compute
  end


  def game_one(key)
    @hsh[key] = yield
  end

  def compute
    @hsh[@another_key]
  end

  def game_two(key)
    @hsh[key] = yield
  end
end


a = Foo.new.start do |config|

  config.game_one('aa') do
    '<div>       \n   </div>'
  end

  config.game_two('bb') do
    '<div>       \n kjsdkaskfsajkfjk   </div>'
  end
end

p a
