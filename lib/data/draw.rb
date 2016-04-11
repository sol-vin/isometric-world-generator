class Draw
  attr_reader :world

  def initialize(world, **options)
    @world = world
    @custom = {}
  end

  def draw_tiles

  end

  def draw_blocks

  end

  def define(name, &block)
    fail "Bad custom name" unless CUSTOM_METHODS.keys.include? name
    fail "Wrong number of arguments for custom" unless CUSTOM_METHODS[name] == block.parameters.count
    @customs[name] = block
  end

  # Used to capture arguments to be passed to a block
  def run(name, *args)
    custom = self[name]
    proc = Proc.new do
      custom.call *args
    end

    world.instance_exec &proc
  end
end