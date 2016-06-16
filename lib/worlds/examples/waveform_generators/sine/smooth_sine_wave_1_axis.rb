class SmoothSineWave1Axis < SineWave1Axis

  def make_passes
    super
    SmootherPass.new(self).install
  end
end