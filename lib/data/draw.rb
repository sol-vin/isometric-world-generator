class Draw
  attr_reader :world

  def initialize(world, **options)
    @world = world
    @custom = {}
  end
end