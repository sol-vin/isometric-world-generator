class DebugAxisColorPass < Pass
  def initialize(world, **options)
    super world, **options

    define :get_block_color do |x, y, z|
      r = (255 * (x.to_f/world.x_range.count)).to_i
      b = (255 * (y.to_f/world.y_range.count)).to_i
      g = (255 * (z.to_f/world.z_range.count)).to_i

      color = 0xFF_000000

      color += r << 16
      color += g << 8
      color += b
      color
    end
  end
end
