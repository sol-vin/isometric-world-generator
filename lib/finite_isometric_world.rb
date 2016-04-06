require_relative './passes'


class FiniteIsometricWorld


  attr_reader :size_x, :size_y, :size_z
  attr_reader :passes
  attr_reader :pen


  def initialize(s_x, s_y, s_z)
    @size_x = s_x
    @size_y = s_y
    @size_z = s_z

    @passes = []
    @pen = IsometricPen.new self
  end

  def init_passes
    @passes.clear

    @passes << Pass.new
  end
end