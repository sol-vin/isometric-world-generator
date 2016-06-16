require_rel './subpasses/'

class SmootherPass
  def initialize(world, **options)
    @world = world
    @options = options
  end

  def install
    @world.passes << RampPass.new(@world)
    @world.passes << RampRotationPass.new(@world)
  end
end
