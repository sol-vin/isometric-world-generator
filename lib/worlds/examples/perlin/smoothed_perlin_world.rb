class SmoothedPerlinWorld < FiniteIsometricWorld
  include PerlinHelper

  def initialize(size_x, size_y, size_z, **options)
    super (0...size_x), (0...size_y), (0...size_z)  , asset_name: :simple, **options

    self.make((rand + 1) * 10000000)
    self.max_height = 10
  end

  def make_passes
    super

    @passes[0] = DebugAxisColorPass.new(self)
    @passes[0].define(:get_tile_type) {|x, y| :tile}
    @passes[0].define(:get_tile_rotation) { |x, y| :deg0}


    @passes[0].define :get_block_type do |x, y, z|
      if z < get_perlin_height(x, y)
        :block
      else
        nil
      end
    end

    @passes[0].define(:get_block_rotation) { |x, y, z| :deg0}

    SmootherPass.new(self).install
  end
end