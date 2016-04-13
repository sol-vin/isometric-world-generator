class SingleBlockLayer < FiniteIsometricWorld
  def initialize(size_x, size_y, size_z)
    super 0, size_x, 0, size_y, 0 , size_z, :simple
  end

  def make_passes
    super

    @passes[0] = Pass.new(self)
    @passes[0].define :get_block_type do |x, y, z|
      if z > 0
        :block
      else
        :none
      end
    end
  end
end