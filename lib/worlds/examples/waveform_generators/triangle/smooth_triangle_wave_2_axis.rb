class SmoothTriangleWave2Axis < TriangleWave2Axis

  def make_passes
    super

    @passes[1] = SmootherPass.new(self)
  end
end