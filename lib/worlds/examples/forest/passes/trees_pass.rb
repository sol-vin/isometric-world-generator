class TreesPass < Pass
  include PerlinHelper

  def initialize(world, **options)
    super world, **options

    self.make((rand + 1) * 10000000)
    self.max_height = 10

    define :get_block_type do |x, y, z|
      b_p = Vector3.new(x - world.x_range.first, y -  world.y_range.first, z -  world.z_range.first)
      neighbors = world.find_neighbors(b_p.x, b_p.y, b_p.z)

      block_type = nil

      if z > 1 and neighbors[:bottom] and neighbors[:bottom].type == :block and (neighbors.count {|k, block| block.type}) == 1
        if get_perlin_bool_3d(x, y, z, 1, 3)
          block_type = :oak_trees_1
        end
      end
      block_type
    end

    define :get_block_color do |x, y, z|
      b_p = Vector3.new(x - world.x_range.first, y -  world.y_range.first, z -  world.z_range.first)
      0xFF_FFFFFF unless world.blocks[b_p.x][b_p.y][b_p.z].type
    end
  end
end