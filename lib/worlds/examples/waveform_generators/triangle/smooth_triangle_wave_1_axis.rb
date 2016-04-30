class SmoothTriangleWave1Axis < TriangleWave1Axis

  def make_passes
    super
    @passes[1] = SmootherPass.new(self)
  end
end
