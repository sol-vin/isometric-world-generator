class RampRotationPass < Pass
  def initialize(world, **options)
    super world, **options
    define(:get_block_rotation) do |x, y, z|
      block_position = Vector3.new(x - world.x_range.first, y -  world.y_range.first, z -  world.z_range.first)

      neighbors = world.find_neighbors(block_position.x, block_position.y, block_position.z)
      neighbors.select! {|direction, block| block.type == :block }

      rotation = :deg0
      if world.blocks[block_position.x][block_position.y][block_position.z].type == :block_ramp
        if neighbors[:front]
          rotation = :deg180
        elsif neighbors[:back]
          rotation = :deg0
        elsif neighbors[:left]
          rotation = :deg90
        elsif neighbors[:right]
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