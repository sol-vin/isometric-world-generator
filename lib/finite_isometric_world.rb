require_relative './passes'


class FiniteIsometricWorld
  #Hash of direction keys, which way the camera is facing and what direction is facing clockwise
  DIRECTIONS = [:north, :south, :east, :west]
  VIEWS = {north_west: :south_west, north_east: :north_west, south_east: :north_east, south_west: :south_east}
  ROTATIONS = [:zero_deg, :ninty_deg, :one_eigth_deg, :two_seventy_deg]

  attr_reader :size_x, :size_y, :size_z

  attr_reader :color_profiles
  attr_reader :passes


  def initialize(s_x, s_y, s_z)
    @size_x = s_x
    @size_y = s_y
    @size_z = s_z

    @passes = []
  end

  def make_passes
    @passes.clear

    @passes << Pass.new
  end
end