class IsometricPen
  attr_reader :canvas
  attr_accessor :x, :y, :z

  def initialize(canvas)
    @canvas = canvas
    @x = 0
    @y = 0
    @z = 0
  end

  def move_to(x, y ,z)

  end

  def move(**options) #{x: 0, y:0, z:0}

  end

  def down

  end

  def up

  end
end