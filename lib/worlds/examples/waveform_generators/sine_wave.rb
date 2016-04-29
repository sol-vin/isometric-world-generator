class SineWave < FiniteIsometricWorld

  def initialize(size_x, size_y, size_z, **options)
    super (0...size_x), (0...size_y), (0...size_z)  , asset_name: :simple, **options
  end

  def make_passes
    super

    @passes[0] = DebugAxisColorPass.new(self)
    @passes[0].define(:get_tile_type) {|x, y| :tile}
    @passes[0].define(:get_tile_rotation) {|x, y| :deg0}

    @passes[0].define :get_block_type do |x, y, z|
      two_pi = 2 * 3.141592
      height = (Math::sin(two_pi * (x - x_range.first)/x_range.count * 8)) * (z_range.count/3) + (z_range.count/3)

      if z < height
        :block
      else
        nil
      end
    end
    @passes[0].define(:get_block_rotation) {|x, y, z| :deg0}
  end
end