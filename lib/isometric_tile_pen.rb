class IsometricBlockPen
  attr_accessor :x, :y

  def initialize()
    @x = 0
    @y = 0
  end

  def move_to(x, y)

  end

  def move(**options) #{x: 0, y:0, z:0}
    x = (options[:x] or 0)
    y = (options[:y] or 0)
  end

  def down

  end

  def up

  end
end