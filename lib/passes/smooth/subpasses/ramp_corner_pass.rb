class RampCornerPass < Pass
  def initialize(world, **options)
    super world, **options

    define :get_block_type do |x, y, z|
      # Get the block position in the world.blocks array
      block_position = Vector3.new(x - world.x_range.first, y - world.y_range.first, z - world.z_range.first)
      block_type = nil

      # if the block is emtpy
      unless world.blocks[block_position.x][block_position.y][block_position.z].type
        neighbors = world.find_neighbors(block_position.x, block_position.y, block_position.z)

        if (!neighbors[:bottom].nil? and [:block, :block_diag_corner, :block_ramp_internal_corner].include?(neighbors[:bottom].type)) or block_position.z == 0
          neighbors.select! {|direction, block| [:block_ramp, :block_ramp_internal_corner].include? block.type}
          if neighbors.count == 2
            unless (neighbors.include?(:front) and neighbors.include?(:back)) or
              (neighbors.include?(:left) and neighbors.include?(:right))

              block_type = :block_ramp_corner
            end
          end
        end
      end
      block_type
    end
  end
end

class RampCornerRotationPass < Pass
  def initialize(world, **options)
    super world, **options
    define(:get_block_rotation) do |x, y, z|
      block_position = Vector3.new(x - world.x_range.first, y -  world.y_range.first, z -  world.z_range.first)

      neighbors = world.find_neighbors(block_position.x, block_position.y, block_position.z)
      neighbors.select! {|direction, block| [:block_ramp, :block_ramp_internal_corner].include? block.type}

      rotation = nil

      if world.blocks[block_position.x][block_position.y][block_position.z].type == :block_ramp_corner
        if neighbors[:front] and neighbors[:left]
          rotation = :deg180
        elsif neighbors[:back] and neighbors[:right]
          rotation = :deg0
        elsif neighbors[:left] and neighbors[:back]
          rotation = :deg90
        elsif neighbors[:right] and neighbors[:front]
          rotation = :deg270
        end
      end
=begin

      if world.blocks[block_position.x][block_position.y][block_position.z].type == :block_diag_corner
        if neighbors[:front] && neighbors[:left]
          rotation = :deg180
        elsif neighbors[:front] && neighbors[:right]
          rotation = :deg270
        elsif neighbors[:back] && neighbors[:left]
          rotation = :deg90
        elsif neighbors[:back] && neighbors[:right]
          rotation = :deg0
        end
      end
=end

      rotation
    end
  end
end