class SmoothSineWave2Axis < SineWave2Axis

  def make_passes
    super
    @passes[1] = SmootherPass.new(self)
  end
end