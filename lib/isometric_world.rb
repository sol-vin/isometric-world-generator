class IsometricWorld
  #Hash of direction keys, which way the camera is facing and what direction is facing clockwise
  DIRECTIONS = [:north, :south, :east, :west]
  VIEWS = {north_west: :south_west, north_east: :north_west, south_east: :north_east, south_west: :south_east}
  ROTATIONS = [:deg0, :deg90, :deg180, :deg270]

  attr_reader :view
  attr_reader :assets

  def initialize(assets_name)
    @assets = IsometricAssets.new(assets_name)
    @view = VIEWS.values.last
  end

  def get_tile_position(x, y)
    spacing = Vector2.new((assets.tile_width/2.0).round, (assets.tile_height/2.0).round)
    Vector2.new((-x * spacing.x) + (y * spacing.x) - y + x + OFFSET.x,
                (x * spacing.y) + (y*spacing.y) - y - x + OFFSET.y)
  end

  def get_block_position(x, y, z)
    position = get_tile_position(x,y)
    position.y -= (assets.block_height / 2.0).round * (z + 1)
    position
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