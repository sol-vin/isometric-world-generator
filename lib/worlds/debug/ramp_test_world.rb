class RampTestWorld < FiniteIsometricWorld
  def initialize(size_x, size_y, size_z, **options)
    super (0...size_x), (0...size_y), (0...size_z)  , asset_name: :simple, **options
  end

  def make_passes
    super

    @passes[0] = Pass.new(self)
    @passes[0].define(:get_tile_type) {|x, y| :tile}
    @passes[0].define(:get_tile_color) {|x, y| 0xFF_FFFFFF}
    @passes[0].define(:get_tile_rotation) {|x, y| :deg0}


    @passes[0].define :get_block_type do |x, y, z|
      if z == 0 and (x+3) % 5 == 0 and (y+3) % 5 == 0
        :block_ramp
      else
        nil
      end
    end

    @passes[0].define :get_block_color do |x, y, z|
      x_median = x_range.count / 2
      y_median = y_range.count / 2

      if x - x_range.first < x_median and y - y_range.first < y_median
        0xFF_FF0000
      elsif x - x_range.first > x_median and y - y_range.first < y_median
        0xFF_00FF00
      elsif x - x_range.first < x_median and y - y_range.first > y_median
        0xFF_0000FF
      elsif x - x_range.first > x_median and y - y_range.first > y_median
        0xFF_FF4400
      else
        0xFF_FFFFFF
      end
    end

    @passes[0].define(:get_block_rotation) do |x, y, z|
      x_median = x_range.count / 2
      y_median = y_range.count / 2

      if x - x_range.first < x_median and y - y_range.first < y_median
        :deg0
      elsif x - x_range.first > x_median and y - y_range.first < y_median
        :deg90
      elsif x - x_range.first < x_median and y - y_range.first > y_median
        :deg270
      elsif x - x_range.first > x_median and y - y_range.first > y_median
        :deg180
      else
        :deg0
      end
    end
  end
end