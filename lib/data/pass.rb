class Pass
  CUSTOM_METHODS = {
      get_tile_type: 2,
      get_tile_rotation: 2,
      get_tile_color: 3,

      get_block_type: 3,
      get_block_rotation: 3,
      get_block_color: 3,
      get_block_decorations: 3
  }

  CUSTOM_DEFAULTS = {
      get_tile_type: :none,
      get_tile_rotation: :zero_deg,
      get_tile_color: 0x000000,

      get_block_type: :none,
      get_block_rotation: :zero_deg,
      get_block_color: 0x000000,
      get_block_decorations: [:none, :none, :none, :none]
  }

  # contains the blocks for generation
  attr_reader :customs
  attr_reader :world

  def initialize(world, **options)
    @world = world
    @customs = {}

    fail "Bad custom name in Pass" if options.keys.any? {|k| CUSTOM_METHODS[k]}
    fail "Custom had wrong number of args" if options.any? {|k, v| CUSTOM_METHODS[k] == v.parameters.count}
    @customs = options.dup
  end

  def get_tile(x, y)
    # Assemble the tile here
  end

  def get_block(x, y, z)
    #assemble the block here
  end

  def try_custom(name, *args)
    if custom[name]
      customs[name].call(*args)
    else
      CUSTOM_DEFAULTS[name]
    end
  end

  CUSTOM_METHODS.keys.each do |method_name, method_args|
    define_method method_name do |*args|
      try_custom(__method__)
    end
  end
end