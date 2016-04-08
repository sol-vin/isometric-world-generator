require_relative './passes'


class FiniteIsometricWorld < IsometricWorld
  attr_reader :size_x, :size_y, :size_z
  attr_reader :view
  attr_reader :passes
  attr_reader :pen
  attr_reader :assets
  attr_reader :blocks

  def initialize(s_x, s_y, s_z, assets_name)
    @size_x = s_x
    @size_y = s_y
    @size_z = s_z

    @assets = IsometricAssets.new(assets_name)

    clear_blocks
    init_passes

    @view = IsometricWorld::VIEWS.values.last

    @pen = IsometricPen.new self
  end

  def init_passes
    @passes = []
  end

  def clear_blocks
    @blocks = Array.new(s_x, Array.new(s_y, Array.new(s_z)))
  end

  def make_blocks
  end

  def set_block(block, pass_number, x, y, z)
    @blocks[x][y][z] = block
  end

  #rotate the view counter clockwise
  def rotate_counter_clockwise
    @view = VIEWS[view]
  end

  #rotate the view clockwise
  def rotate_clockwise
    @view = VIEWS.invert[view]
  end
end