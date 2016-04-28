class HollowCubes < FiniteIsometricWorld

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
      mod_x = x % 7
      mod_y = y % 7

      type = nil

      if z < 5
        if ((1..5) === mod_x)&& ((1..5) === mod_y)
          type = :block
          if ((2..4) === mod_x) || ((2..4) === mod_y)
            if (1..3) === z
              type = nil
            end
          end
        end
      end
      type
    end

    @passes[0].define :get_block_color do |x, y, z|
      case z
        when 0
          0xFF_FFFF00
        when 1
          0xFF_FFBB00
        when 2
          0xFF_FF8800
        when 3
          0xFF_FF4400
        when 4
          0xFF_FF0000
      end
    end

    @passes[0].define(:get_block_rotation) {|x, y, z| :deg0}

  end
end