require_rel './subpasses/'

class SmootherPass
  def initialize(world, **options)
    @world = world
    @options = options
  end

  def install
    @world.passes << RampPass.new(@world)
    @world.passes << RampRotationPass.new(@world)
    @world.passes << RampInternalCornerPass.new(@world)
    @world.passes << RampInternalCornerRotationPass.new(@world)
    @world.passes << RampCornerPass.new(@world)
    @world.passes << RampCornerRotationPass.new(@world)
    #@world.passes << DiagCornerPass.new(@world)
    #@world.passes << DiagCornerRotationPass.new(@world)
  end
end
