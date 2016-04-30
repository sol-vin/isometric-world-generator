class SquareWave2Axis < FiniteIsometricWorld

  def initialize(size_x, size_y, size_z, **options)
    super (0...size_x), (0...size_y), (0...size_z)  , asset_name: :simple, **options
  end

  def make_passes
    super

    @passes[0] = DebugAxisColorPass.new(self)
    @passes[0].define(:get_tile_type) {|x, y| :tile}
    @passes[0].define(:get_tile_rotation) {|x, y| :deg0}

    @passes[0].define :get_block_type do |x, y, z|
      wave_height = 10
      wave_length = 10

      if x % wave_length*2 < wave_length and y % wave_length*2 < wave_length and z < wave_height
        :block
      else
        nil
      end
    end
    @passes[0].define(:get_block_rotation) {|x, y, z| :deg0}
  end
end