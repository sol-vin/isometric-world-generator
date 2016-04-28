class TileTerrain < FiniteIsometricWorld
  include PerlinHelper

  TYPES = {ocean: 0, sand: 0.3, grass: 1}

  def initialize(size_x, size_y, size_z, **options)
    super (0...size_x), (0...size_y), (0...size_z)  , asset_name: :simple, **options

    self.seed = (rand * 1000)
    self.max_height = 10
  end

  def make_passes
    super

    @passes[0] = DebugAxisColorPass.new(self)
    @passes[0].define(:get_tile_type) {|x, y| :tile}
    @passes[0].define(:get_tile_rotation) { |x, y| :deg0}

    @passes[0].define(:get_tile_color) do |x, y|
      noise = get_perlin_noise(x, y)

      type = TYPES.to_a.find do |type_and_threshold|
        if noise < type_and_threshold.last
          true
        else
          false
        end
      end

      type = type.first

      case type
        when :ocean
          0xFF_0093F5
        when :sand
          0xFF_F2BF6D
        when :grass
          0xFF_229C0C
        else
          0xFF_FFFFFF
      end
    end
  end
end