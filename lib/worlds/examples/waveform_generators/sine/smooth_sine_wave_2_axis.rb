class SmoothSineWave2Axis < SineWave2Axis

  def make_passes
    super
    SmootherPass.new(self).install
  end
end