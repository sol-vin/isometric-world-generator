class SmoothTriangleWave1Axis < TriangleWave1Axis

  def make_passes
    super
    SmootherPass.new(self).install
  end
end
