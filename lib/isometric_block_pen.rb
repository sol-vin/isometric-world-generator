class IsometricBlockPen
  attr_accessor :x, :y, :z

  def initialize()
    up
    move_to(0,0,0)
  end

  def move_to(x, y ,z)
    @x = x
    @y = y
    @z = z
  end

  def move(**options) #{x: 0, y:0, z:0}
    mx = (options[:x] or 0)
    my = (options[:y] or 0)
    mz = (options[:z] or 0)

    @x += mx
    @y += my
    @z += mz
  end

  def down
    @drawing = true
  end

  def up
    @drawing = false
  end
end