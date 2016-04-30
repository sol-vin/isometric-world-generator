class SmoothSineWave1Axis < SineWave1Axis

  def make_passes
    super
    @passes[1] = SmootherPass.new(self)
  end
end