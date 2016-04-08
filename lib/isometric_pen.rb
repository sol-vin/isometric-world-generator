class IsometricPen
  attr_reader :world
  attr_accessor :x, :y, :z

  def initialize(world)
    @world = world
    @x = 0
    @y = 0
    @z = 0
  end

  def move_to(x, y ,z)

  end

  def move(**options) #{x: 0, y:0, z:0}
    x = (options[:x] or 0)
    y = (options[:y] or 0)
    z = (options[:z] or 0)

  end

  def down

  end

  def up

  end

  def make_draw &block
    instance_exec &block
  end
end