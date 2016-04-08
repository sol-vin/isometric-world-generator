class Draw
  attr_reader :pen
  attr_reader :block

  def intialize(pen, block)
    @pen = pen
    @block = block
  end

  def draw
    pen.instance_exec &block
  end
end