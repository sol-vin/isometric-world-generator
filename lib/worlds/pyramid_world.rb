class PyramidWorld < FiniteIsometricWorld
  def initialize(size_x, size_y, size_z, **options)
    super (0...size_x), (0...size_y), (0...size_z)  , asset_name: :simple, **options
  end

  def make_passes
    super

    @passes[0] = Pass.new(self)
    @passes[0].define :get_block_type do |x, y, z|
      mod_x = x % 5
      mod_y = y % 5

      if z == 1 and mod_x == 3 and mod_y == 3
        :block
      elsif z == 0 and (2..4).include?(mod_x) and (2..4).include?(mod_y)
        :block
      else
        nil
      end
    end

    @passes[0].define :get_block_color do
      0xFF_FF0000
    end
  end
end