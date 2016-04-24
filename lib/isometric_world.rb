require_relative './isometric_worlds'

class IsometricWorld

  class << self
    def inherited(base)
      IsometricWorlds[base.to_s.to_sym] = base
    end
  end

  #Hash of direction keys, which way the camera is facing and what direction is facing clockwise
  DIRECTIONS = [:north, :south, :east, :west]
  VIEWS = {north_west: :south_west, north_east: :north_west, south_east: :north_east, south_west: :south_east}
  ROTATIONS = [:deg0, :deg90, :deg180, :deg270]

  attr_reader :view
  attr_reader :assets

  # should we draw the tiles or blocks?
  attr_accessor :draw_tiles, :draw_blocks
  alias_method :draw_tiles?, :draw_tiles
  alias_method :draw_blocks?, :draw_blocks

  def initialize(**options)
    @assets = IsometricAssets.new(options[:asset_name])
    @view = VIEWS.values.last
    @draw_tiles = true
    @draw_blocks = true
  end

  def get_tile_position(x, y)
    spacing = Vector2.new((assets.tile_width/2.0).round, (assets.tile_height/2.0).round)
    Vector2.new((-x * spacing.x) + (y * spacing.x) - y + x,
                (x * spacing.y) + (y*spacing.y) - y - x)
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

require_rel '/worlds/'