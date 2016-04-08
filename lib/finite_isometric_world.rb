require_relative './passes'


class FiniteIsometricWorld < IsometricWorld
  attr_reader :size_x, :size_y, :size_z
  attr_reader :passes
  attr_reader :pen
  attr_reader :tiles
  attr_reader :blocks

  def initialize(s_x, s_y, s_z, assets_name)
    super assets_name
    @size_x = s_x
    @size_y = s_y
    @size_z = s_z


    clear_tiles
    clear_blocks
    init_passes
    @pen = IsometricPen.new self
  end

  def init_passes
    @passes = {}
  end

  def init_draws
    @draws = {}
  end

  def clear_tiles
    @btiles = Array.new(s_x, Array.new(s_y, Array.new(s_z)))
  end


  def clear_blocks
    @blocks = Array.new(s_x, Array.new(s_y, Array.new(s_z)))
  end

  def get_tile_position(x, y)
    spacing = Vector2.new((assets.width/2.0).round, (assets.height/2.0).round)
    Vector2.new((-x * spacing.x) + (y * spacing.x) - y + x + OFFSET.x,
                (x * spacing.y) + (y*spacing.y) - y - x + OFFSET.y)
  end

  def get_block_position(x, y, z)
    position = get_tile_position(x,y)
    position.y -= (assets.block_height / 2.0).round * (z + 1)
    position
  end

  def make_blocks
    @passes.sort!{|a, b| a[0] <=> b[0]}
    @draws.sort!{|a, b| a[0] <=> b[0]}


  end
end