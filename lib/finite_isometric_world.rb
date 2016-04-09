require_relative './passes'


class FiniteIsometricWorld < IsometricWorld
  attr_reader :x_range, :y_range, :z_range
  attr_reader :passes
  attr_reader :pen
  attr_reader :tiles
  attr_reader :blocks

  def initialize(x_range, y_range, z_range, assets_name)
    super assets_name
    @x_range = x_range
    @y_range = y_range
    @z_range = z_range


    clear_tiles
    clear_blocks
    init_passes
    @pen = IsometricPen.new self
  end

  def init_passes
    @passes = {}
  end

  def init_draws
    @draws = {}
  end

  def clear_tiles
    @tiles = Array.make_2d_array(size_x, size_y, :none)
  end


  def clear_blocks
    @blocks = Array.make_3d_array(size_x, size_y, size_z, :none)
  end

  def each_block
    x_range.each do |x|
      y_range.each do |y|
        z_range.each do |z|
          yield x, y, z
        end
      end
    end
  end

  def make_blocks
    # combine the passes and draws so draws come after passes if on the same level
    operations = passes.keys.map{|p| p.to_s + "a"} + draws.keys.map{|d| d.to_s + "b"}
    operations.sort!
    operations.map! do |op|
      if op.include? "a"
        passes[op.gsub(/a/, '').to_i]
      elsif op.include? "b"
        draws[op.gsub(/b/, '').to_i]
      end
    end

    # Make a blank canvas
    canvas = Array.make_3d_array(size_x, size_y, size_z)

    # Run each draw or pass
    operations.each do |op|
      if op.is_a? Pass
        each_block do |x, y, z|
          canvas[x][y][z] = op.get_block(start_x + x, start_y + y, start_z + z)
        end
      elsif op.is_a? Draw
        op.draw canvas
      end

      #merge the arrays after the pass/draw to
      size_x.times do |x|
        size_y.times do |y|
          size_z.times do |z|
            @blocks[x][y][z] = canvas[x][y][z] if canvas[x][y][z]
          end
        end
      end
    end
  end
end