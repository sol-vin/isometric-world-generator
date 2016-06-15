class RampCornerTestWorld < FiniteIsometricWorld
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
      mod_x = x % 4
      mod_y = y % 4

      if z == 0
        if (mod_x == 1 || mod_x == 2) && (mod_y == 1 || mod_y == 2)
          :block_ramp_corner
        end
      end
    end

    @passes[0].define :get_block_color do |x, y, z|
      0xFF_FF0000
    end

    @passes[0].define(:get_block_rotation) do |x, y, z|
      mod_x = x % 4
      mod_y = y % 4

      if mod_x == 1
        if mod_y == 1
         :deg0
        elsif mod_y == 2
          :deg270
        end
      elsif mod_x == 2
        if mod_y == 1
          :deg90
        elsif mod_y == 2
          :deg180
        end
      end
    end
  end
end