class RampPass < Pass
  def initialize(world, **options)
    super world, **options

    define :get_block_type do |x, y, z|
      # Get the block position in the world.blocks array
      block_position = Vector3.new(x - world.x_range.first, y - world.y_range.first, z - world.z_range.first)
      block_type = nil

      # if the block is emtpy
      unless world.blocks[block_position.x][block_position.y][block_position.z].type
        neighbors = world.find_neighbors(block_position.x, block_position.y, block_position.z)
        neighbors.select! {|direction, block| block.type == :block }

        #ramp check

        if (neighbors[:bottom] or block_position.z == 0) and (neighbors.keys & [:front, :left, :back, :right]).count == 1 and not neighbors[:top]
          block_type = :block_ramp
        end
      end

      block_type
    end
  end
end