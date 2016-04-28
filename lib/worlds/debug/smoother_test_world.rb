class SmootherTestWorld < FiniteIsometricWorld

  def initialize(size_x, size_y, size_z, **options)
    super (0...size_x), (0...size_y), (0...size_z)  , asset_name: :simple, **options
  end

  def make_passes
    super

    @passes[0] = Pass.new(self)
    @passes[0].define(:get_tile_type) {|x, y| :tile}
    @passes[0].define(:get_tile_rotation) { |x, y| :deg0}
    @passes[0].define(:get_tile_color) { |x, y| 0xFF_0000FF}


    @passes[0].define :get_block_type do |x, y, z|
      x_median = x_range.count / 2
      y_median = x_range.count / 2

      if (x == x_median or y == y_median) and z == 0
        :block
      else
        nil
      end
    end
    @passes[0].define(:get_block_color) { |x, y, z| 0xFF_00FF00}
    @passes[0].define(:get_block_rotation) { |x, y, z| :deg0}


    @passes[1] = Pass.new(self)
    @passes[1].define :get_block_type do |x, y, z|
      block_position = Vector3.new(x - x_range.first, y - y_range.first, z - z_range.first)

      if !blocks[block_position.x][block_position.y][block_position.z].type
        viable = find_viable_ramp_neighbors(x, y, z)
        if viable.count == 1 and (z == z_range.first or blocks[block_position.x][block_position.y][block_position.z-1].type == :block)
          :block_ramp
        else
          nil
        end
      else
        nil
      end
    end

    @passes[1].define(:get_block_rotation) do |x, y, z|
      block_position = Vector3.new(x - x_range.first, y - y_range.first, z - z_range.first)

      viable = find_viable_ramp_neighbors(x, y, z)

      if blocks[block_position.x][block_position.y][block_position.z].type == :block
        :deg0
      elsif viable.keys.include?(:front)
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
      block_position = Vector3.new(x - x_range.first, y - y_range.first, z - z_range.first)

      if blocks[block_position.x][block_position.y][block_position.z].type == :block
        0xFF_00FF00
      elsif find_viable_ramp_neighbors(x, y, z).count == 1
        0xFF_FF0000
      else
        0xFF_FF0000
      end
    end
  end

  def find_viable_ramp_neighbors(x, y, z)
    possible_neighbors = {front: [0,1], left: [1,0], right: [-1,0], back: [0,-1]}
    block_position = Vector3.new(x - x_range.first, y - y_range.first, z - z_range.first)

    possible_neighbors.select do |name, position|
      skip_neighbor = !(x_range.include?(x - position.first) and
                        y_range.include?(y - position.last))
      skip_top_z_neighbor = !(z_range.include?(z+1))
      if skip_neighbor
        false
      else
        base_neighbor = blocks[block_position.x - position.first][block_position.y - position.last][block_position.z]
        if base_neighbor.type
          if skip_top_z_neighbor
            true
          else
            base_neighbor_above = blocks[block_position.x - position.first][block_position.y - position.last][block_position.z+1]
            base_neighbor_above.type.nil?
          end
        else
          false
        end
      end
    end
  end
end