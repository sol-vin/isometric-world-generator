class TerrainPass < Pass
  include PerlinHelper

  def initialize(world, **options)
    super world, **options

    self.make((rand + 1) * 10000000)
    self.max_height = 10

    define(:get_tile_color) {|x, y| 0xFF_0000FF}
    define(:get_block_color) do |x, y, z|
      b_p = Vector3.new(x - world.x_range.first, y -  world.y_range.first, z -  world.z_range.first)
      neighbors = world.find_neighbors(b_p.x, b_p.y, b_p.z)

      color = nil

      max_neighbors = 6

      max_neighbors -= 1 if b_p.x == 0
      max_neighbors -= 1 if b_p.y == 0
      max_neighbors -= 1 if b_p.z == 0

      max_neighbors -= 1 if b_p.x == world.x_range.count-1
      max_neighbors -= 1 if b_p.y == world.y_range.count-1
      max_neighbors -= 1 if b_p.z == world.z_range.count-1

      neighbor_count = neighbors.count {|direction, block| block.type}

      if b_p.z == 0 and ((neighbors[:top] and not neighbors[:top].type) or not neighbors[:top])
        color = 0xFF_F7F36F
      elsif neighbor_count == max_neighbors and (neighbors[:top] and neighbors[:top].type and neighbors[:top].type != :block_ramp_corner)
        color = 0xFF_523D02
      else
        color = 0xFF_007A1D
      end

      color
    end
  end
end