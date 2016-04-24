#I love this in ruby, write a struct, then have it automagically
#write all the arithmetic for you.
class Vector2 < Struct.new(:x, :y)
  class << self
    def one
      Vector2.new(1, 1)
    end

    def zero
      Vector2.new(0, 0)
    end
  end

  [:+ , :-, :*, :/].each do |method|
    define_method method do |other|
      Vector2.new(self.x.send(method, other.x), self.y.send(method, other.y))
    end
  end

  def == other
    self.x == other.x and self.y == other.y
  end
end

class Vector3 < Struct.new(:x, :y, :z)
  class << self
    def one
      Vector3.new(1, 1, 1)
    end

    def zero
      Vector3.new(0, 0, 0)
    end
  end

  [:+ , :-, :*, :/].each do |method|
    define_method method do |other|
      Vector2.new(self.x.send(method, other.x), self.y(method, other.y))
    end
  end

  def == other
    self.x == other.x and self.y == other.y and self.z == other.z
  end
end