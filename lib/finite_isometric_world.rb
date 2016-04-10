require_relative './passes'


class FiniteIsometricWorld < IsometricWorld
  attr_reader :x_range, :y_range, :z_range
  attr_reader :passes
  attr_reader :draws
  attr_reader :pen
  attr_reader :tiles
  attr_reader :blocks

  attr_reader :tile_canvas
  attr_reader :block_canvas

  def initialize(x_range, y_range, z_range, assets_name)
    super assets_name
    @x_range = x_range
    @y_range = y_range
    @z_range = z_range


    clear_tiles
    clear_tile_canvas
    clear_blocks
    clear_block_canvas
    make_passes
    make_draws
    @block_pen = IsometricBlockPen.new self
    @tile_pen = IsometricTilePen.new self
  end

  def clear_passes
    @passes = []
  end

  def clear_draws
    @draws = {}
  end

  def clear_tiles
    @tiles = Array.make_2d_array(size_x, size_y, :none)
  end

  def clear_tile_canvas
    @tile_canvas = Array.make_2d_array(size_x, size_y)
  end


  def clear_blocks
    @blocks = Array.make_3d_array(size_x, size_y, size_z, :none)
  end

  def clear_block_canvas
    @block_canvas = Array.make_3d_array(size_x, size_y, size_z)
  end

  def make_passes
    clear_passes
  end

  def make_draws
    clear_draws
  end

  def merge_canvases
    size_x.times do |x|
      size_y.times do |y|
        tiles[x][y] = tile_canvas[x][y] if tile_canvas[x][y]
      end
    end

    size_x.times do |x|
      size_y.times do |y|
        size_z.times do |z|
          @blocks[x][y][z] = block_canvas[x][y][z] if block_canvas[x][y][z]
        end
      end
    end
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

  def each_tile
    x_range.each do |x|
      y_range.each do |y|
        yield x, y
      end
    end
  end

  def make_operations
    operations = passes.keys.map{|p| p.to_s + "a"} + draws.keys.map{|d| d.to_s + "b"}
    operations.sort!
    operations.map! do |op|
      if op.include? "a"
        passes[op.gsub(/a/, '').to_i]
      elsif op.include? "b"
        draws[op.gsub(/b/, '').to_i]
      end
    end
    operations
  end

  def run_tile_pass(pass)
    each_tile do |x, y|
      tile_canvas[x][y] = pass.get_tile(start_x + x, start_y + y)
    end
  end

  def run_block_pass(pass)
    each_block do |x, y, z|
      block_canvas[x][y][z] = pass.get_block(start_x + x, start_y + y, start_z + z)
    end
  end

  def run_draw(draw)
    fail NotImplementedError.new
  end

  def make_world
    make_operations.each do |op|
      case op.class
        when Pass
          run_tile_pass op
          run_block_pass op
        when Draw
          run_draw op
        else
          fail
      end
      merge_canvases
    end
  end

  def draw_tile(x_pos, y_pos, x, y)

  end

  def draw_tiles
    case view
      when :south_east
        size_y.times do |y|
          size_x.times do |x|
            draw_tile(x, y, x, y)
          end
        end
      when :south_west
        size_x.times do |y|
          size_y.times do |x|
            draw_tile(x, y, size_x - 1 - y, x)
          end
        end
      when :north_west
        size_y.times do |y|
          size_x.times do |x|
            draw_tile(x, y, size_x - 1 - x, size_y - 1- y)
          end
        end
      when :north_east
        size_x.times do |y|
          size_y.times do |x|
            draw_tile(x, y, y, size_y - 1 - x)
          end
        end
      else
        throw Exception.new("view was out of bounds!")
    end
  end

  def draw_block(x_pos, y_pos, z_pos, x, y, z)

  end

  def draw_blocks
    case view
      when :south_east
        size_y.times do |y|
          size_x.times do |x|
            size_z.times do |z|
              draw_block(x, y, z, x, y, z)
            end
          end
        end
      when :south_west
        size_x.times do |y|
          size_y.times do |x|
            size_z.times do |z|
              draw_block(x, y, z, size_x - 1 - y, x, z)
            end
          end
        end
      when :north_west
        size_y.times do |y|
          size_x.times do |x|
            size_z.times do |z|
              draw_block(x, y, z, size_x - 1 - x, size_y - 1 - y, z)
            end
          end
        end
      when :north_east
        size_x.times do |y|
          size_y.times do |x|
            size_z.times do |z|
              draw_block(x, y, z, y, size_y - 1 - x, z)
            end
          end
        end
      else
        throw Exception.new("view was out of bounds!")
    end
  end
end