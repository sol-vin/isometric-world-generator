class IsometricWorld
  #Hash of direction keys, which way the camera is facing and what direction is facing clockwise
  DIRECTIONS = [:north, :south, :east, :west]
  VIEWS = {north_west: :south_west, north_east: :north_west, south_east: :north_east, south_west: :south_east}
  ROTATIONS = [:deg0, :deg90, :deg180, :deg270]

  attr_reader :view
  attr_reader :assets

  def initialize
    @assets = IsometricAssets.new(assets_name)
    @view = VIEWS.values.last

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