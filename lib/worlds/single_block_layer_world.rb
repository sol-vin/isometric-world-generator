class SingleBlockLayerWorld < FiniteIsometricWorld
  def initialize(size_x, size_y, size_z, **options)
    super (0...size_x), (0...size_y), (0...size_z)  , asset_name: :simple, **options
  end

  def make_passes
    super

    @passes[0] = Pass.new(self)
    @passes[0].define :get_block_type do |x, y, z|
      if z == 0
        :block
      else
        nil
      end
    end
  end
end