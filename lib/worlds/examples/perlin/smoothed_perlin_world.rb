class SmoothedPerlinWorld < FiniteIsometricWorld
  include PerlinHelper

  def initialize(size_x, size_y, size_z, **options)
    super (0...size_x), (0...size_y), (0...size_z)  , asset_name: :simple, **options

    self.seed = (rand * 10000000)
    self.max_height = 10
  end

  def make_passes
    super

    @passes[0] = Pass.new(self)
    @passes[0].define(:get_tile_type) {|x, y| :tile}
    @passes[0].define(:get_tile_rotation) { |x, y| :deg0}
    @passes[0].define(:get_tile_color) { |x, y| 0xFF_0000FF}


    @passes[0].define :get_block_type do |x, y, z|
      if z < get_perlin_height(x, y)
        :block
      else
        nil
      end
    end

    @passes[0].define(:get_block_rotation) { |x, y, z| :deg0}


    @passes[1] = Pass.new(self)
    @passes[1].define :get_block_type do |x, y, z|
      if blocks[x][y][z].type != :block
        viable = find_viable_ramp_neighbors(x, y, z)
        if viable.count > 0 and (blocks[x][y][z-1]&.type == :block or z == z_range.first)
          :block_ramp
        else
          nil
        end
      else
        nil
      end
    end

    @passes[1].define(:get_block_rotation) do |x, y, z|
      viable = find_viable_ramp_neighbors(x, y, z)

      if viable.keys.include?(:front)
        :deg180
      elsif viable.keys.include?(:back)
        :deg0
        elsif viable.keys.include?(:left)
        :deg90
      elsif viable.keys.include?(:right)
        :deg270
      else
        :deg0
      end
    end

    @passes[1].define(:get_block_color) do |x, y, z|
      if blocks[x][y][z].type == :block
        0xFF_00FF00
      elsif find_viable_ramp_neighbors(x, y, z).count > 0
        0xFF_FF0000
      else
        0xFF_FFFFFF
      end
    end

  end

  def find_viable_ramp_neighbors(x, y, z)
    possible_neighbors = {front: [0,1], left: [1,0], right: [-1,0], back: [0,-1]}

    possible_neighbors.select do |name, position|
      skip_neighbor = !(x_range.include?(x - position.first) and y_range.include?(y - position.last))
      skip_top_z_neighbor = !(z_range.include?(z+1))

      if skip_neighbor
        false
      else
        if blocks[x - position.first][y - position.last][z].type == :block
          if skip_top_z_neighbor
            true
          else
            blocks[x - position.first][y - position.last][z+1].type != :block
          end
        else
          false
        end
      end
    end
  end
end