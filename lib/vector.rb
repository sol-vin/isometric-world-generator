#I love this in ruby, write a struct, then have it automagically
#write all the arithmetic for you.
class Vector2 < Struct.new(:x, :y)
  def method_missing(name, *args)
    #Check to see if the method name is one char long
    #If so, it's most likely an operation like +, -, *, /
    #Just in case there is a one letter method,
    #also check to ensure there is only one arg
    if name.length == 1 && args.length == 1
      Vector2.new(x.send(name, args.first.x), y.send(name, args.first.y))
    end
  end

  class << self
    def one
      Vector2.new(1, 1)
    end

    def zero
      Vector2.new(0, 0)
    end
  end
end

class Vector3 < Struct.new(:x, :y, :z)
  def method_missing(name, *args)
    #Check to see if the method name is one char long
    #If so, it's most likely an operation like +, -, *, /
    #Just in case there is a one letter method,
    #also check to ensure there is only one arg
    if name.length == 1 && args.length == 1
      Vector3.new(x.send(name, args.first.x), y.send(name, args.first.y), z.send(name, args.first.z))
    end
  end

  class << self
    def one
      Vector3.new(1, 1, 1)
    end

    def zero
      Vector3.new(0, 0, 0)
    end
  end
end