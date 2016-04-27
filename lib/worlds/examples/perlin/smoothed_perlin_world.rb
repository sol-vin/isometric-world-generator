class SmoothedPerlinWorld < FiniteIsometricWorld
  include PerlinHelper

  def initialize(size_x, size_y, size_z, **options)
    super (0...size_x), (0...size_y), (0...size_z)  , asset_name: :simple, **options

    self.seed = (rand * 10000000)
    self.max_height = 10
  end

  def make_passes
    super

    @passes[0] = DebugAxisColorPass.new(self)
    @passes[0].define(:get_tile_type) {|x, y| :tile}

    @passes[0].define :get_block_type do |x, y, z|
      if z < get_perlin_height(x, y)
        :block
      else
        nil
      end
    end

    @passes[1] = Pass.new(self)
    @passes[1].define(:get_block_type) do |x, y, z|
      
    end

    @passes[1].define(:get_block_rotation) do |x, y, z|

    end
  end

  def find_viable_ramp_neighbors(x, y, z)
    possible_neighbors = [[0,1], [1,0], [-1,0], [0,-1]]

    viable_neighbors = possible_neighbors.select do |neighbor|
      base_neighbor = blocks[x - neighbor.first][y - neighbor.last][z]
      if base_neighbor and blocks[x - neighbor.first][y - neighbor.last][z-1]
        true
      else
        false
      end
    end
  end
end