require_relative '../helpers/perlin_helper'

class BasicPerlinWorld < FiniteIsometricWorld
  include PerlinHelper

  def initialize(size_x, size_y, size_z, **options)
    super (0...size_x), (0...size_y), (0...size_z)  , asset_name: :simple, **options

    self.seed = (rand * 10000000).to_i
    self.max_height = 10
  end

  def make_passes
    super

    @passes[0] = Pass.new(self)
    @passes[0].define(:get_tile_type) {|x, y| :tile}

    @passes[0].define :get_block_type do |x, y, z|
      if z < get_perlin_height(x, y)
        :block
      else
        nil
      end
    end

    @passes[0].define :get_block_color do |x, y, z|
      r = (255 * (x.to_f/x_range.count)).to_i
      b = (255 * (y.to_f/y_range.count)).to_i
      g = (255 * (z.to_f/z_range.count)).to_i

      color = 0xFF_000000

      color += r << 16
      color += g << 8
      color += b
      color
    end
  end
end