class SmootherPass < Pass
  def initialize(world, **options)
    super world, **options

    define :get_block_type do |x, y, z|
      block_position = Vector3.new(x - world.x_range.first, y - world.y_range.first, z - world.z_range.first)

      if !world.blocks[block_position.x][block_position.y][block_position.z].type
        viable = find_viable_ramp_neighbors(x, y, z)
        if viable.count > 0 and (z == world.z_range.first or world.blocks[block_position.x][block_position.y][block_position.z-1].type == :block)
          :block_ramp
        else
          nil
        end
      else
        nil
      end
    end

    define(:get_block_rotation) do |x, y, z|
      block_position = Vector3.new(x - world.x_range.first, y -  world.y_range.first, z -  world.z_range.first)

      viable = find_viable_ramp_neighbors(x, y, z)

      if world.blocks[block_position.x][block_position.y][block_position.z].type == :block
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
  end

  def find_viable_ramp_neighbors(x, y, z)
    possible_neighbors = {front: [0,1], left: [1,0], right: [-1,0], back: [0,-1]}

    possible_neighbors.select do |name, position|
      skip_neighbor = !(world.x_range.include?(x - position.first) and
          world.y_range.include?(y - position.last))
      skip_top_z_neighbor = !(world.z_range.include?(z+1))
      if skip_neighbor
        false
      else
        base_neighbor = world.blocks[x - position.first][y - position.last][z]
        if base_neighbor.type
          if skip_top_z_neighbor
            true
          else
            base_neighbor_above = world.blocks[x - position.first][y - position.last][z+1]
            base_neighbor_above.type.nil?
          end
        else
          false
        end
      end
    end
  end
end
