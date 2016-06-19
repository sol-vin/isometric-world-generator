require_rel './passes/'

class ForestWorld < FiniteIsometricWorld
  include PerlinHelper

  def initialize(size_x, size_y, size_z, **options)
    super (0...size_x), (0...size_y), (0...size_z)  , asset_name: :forest, **options
  end

  def make_passes
    super
    @passes << HeightmapPass.new(self)
    SmootherPass.new(self).install
    @passes << TerrainPass.new(self)
    @passes << TreesPass.new(self)
  end
end