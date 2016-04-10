class Draw
  attr_reader :pen
  attr_reader :block
  attr_reader :canvas

  def initialize(pen, &block)
    @pen = pen
    @block = block
  end

  def draw canvas
    pen.world.instance_exec &block
  end
end