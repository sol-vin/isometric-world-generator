class AxisTesterWorld < FiniteIsometricWorld
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
      if x == 0 or y == 0 or z == 0
        :block
      else
        nil
      end
    end

    @passes[0].define :get_block_color do |x, y, z|
      if x == 0
        0xFF_FF0000
      elsif y == 0
        0xFF_00FF00
      elsif z == 0
        0xFF_0000FF
      end
    end

    @passes[0].define(:get_block_rotation) {|x, y, z| :deg0}
  end
end