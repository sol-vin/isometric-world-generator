class SmoothTriangleWave2Axis < TriangleWave2Axis

  def make_passes
    super

    SmootherPass.new(self).install
  end
end