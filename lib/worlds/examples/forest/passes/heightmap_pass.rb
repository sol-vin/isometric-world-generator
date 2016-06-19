class HeightmapPass < Pass
  include PerlinHelper

  def initialize(world, **options)
    super world, **options

    self.make((rand + 1) * 10000000)
    self.max_height = 10

    define(:get_tile_type) {|x, y| :tile}
    define(:get_tile_rotation) {|x, y| :deg0}
    define(:get_tile_color) {|x, y| 0xFF_FFFFFF}
    define :get_block_type do |x, y, z|
      if z < get_perlin_height(x, y)
        :block
      else
        nil
      end
    end
    define(:get_block_rotation) {|x, y, z| :deg0}
    define(:get_block_color) {|x, y, z| 0xFF_FFFFFF}
  end
end