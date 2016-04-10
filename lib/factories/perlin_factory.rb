require 'perlin'

class FinitePerlinFactory < FiniteIsometricWorld

  PERLIN_STEP = 0.02
  PERLIN_OCTAVE = 8
  PERLIN_PERSIST = 0.03
  PERLIN_VALUE_MULTIPLIER = 9

  attr_accessor :perlin_height_diminish

  attr_reader :seed

  def initialize(asset_name, size_x, size_y, size_z, seed)
    super(asset_name, size_x, size_y, size_z)
    self.seed = seed
    @perlin_height_diminish = 1.0
  end

  #new methods

  def seed=(value)
    @seed = value
    @perlin_noise = Perlin::Generator.new(seed, PERLIN_PERSIST, PERLIN_OCTAVE)
    make_blocks
  end


  def get_perlin_height(x, y)
    (get_perlin_noise(x, y) * size_z) * perlin_height_diminish
  end

  #gets perlin noise values from the generator

  def get_perlin_noise(*args)
    case args.length
      when 1
        get_perlin_noise_1d(args[0])
      when 2
        get_perlin_noise_2d(args[0], args[1])
      when 3
        get_perlin_nosie_3d(args[0], args[1], args[2])
    end
  end

  def get_perlin_noise_1d(x)
    #TODO: Fix this
    (@perlin_noise[x * PERLIN_STEP, 0] + 1) / 2.0
  end

  def get_perlin_noise_2d(x, y)
    (@perlin_noise[x * PERLIN_STEP, y * PERLIN_STEP] + 1) / 2.0
  end

  def get_perlin_noise_3d(x, y, z)
    (@perlin_noise[x * PERLIN_STEP, y * PERLIN_STEP, z * PERLIN_STEP] + 1) / 2.0
  end

  #gets a random number from the noise generator
  def get_perlin_int(*args)
    case args.length
      when 3
        get_perlin_int_1d(args[0], args[1], args[2])
      when 4
        get_perlin_int_2d(args[0], args[1], args[2], args[3])
      when 5
        get_perlin_int_3d(args[0], args[1], args[2], args[3], args[4])
    end
  end

  def get_perlin_int_1d(x, low, high)
    throw Exception.new("start must be less than end!") if low >= high
    (get_perlin_noise_1d(x).to_s[-7..-1].to_i % (high-low)) + low
  end

  def get_perlin_int_2d(x, y, low, high)
    throw Exception.new("start must be less than end!") if low >= high
    (get_perlin_noise_2d(x,y).to_s[-7..-1].to_i % (high-low)) + low
  end

  def get_perlin_int_3d(x, y, z, low, high)
    throw Exception.new("start must be less than end!") if low >= high
    (get_perlin_noise_3d(x,y,z).to_s[-7..-1].to_i % (high-low)) + low
  end

  def get_perlin_float(*args)
    case args.length
      when 3
        get_perlin_float_1d(args[0], args[1], args[2])
      when 4
        get_perlin_float_2d(args[0], args[1], args[2], args[3])
      when 5
        get_perlin_float_3d(args[0], args[1], args[2], args[3], args[4])
    end
  end


  def get_perlin_float_1d(x, low, high)
    throw Exception.new("start must be less than end!") if low >= high
    (get_perlin_noise_1d(x).to_s[-7..-1].prepend('.').to_f % (high-low)) + low
  end

  def get_perlin_float_2d(x, y, low, high)
    throw Exception.new("start must be less than end!") if low >= high
    (get_perlin_noise_2d(x,y).to_s[-7..-1].prepend('.').to_f % (high-low)) + low
  end

  def get_perlin_float_3d(x, y, z, low, high)
    throw Exception.new("start must be less than end!") if low >= high
    (get_perlin_noise_3d(x,y,z).to_s[-7..-1].prepend('.').to_f % (high-low)) + low
  end

  #gets a boolean value out of the perlin generator
  def get_perlin_bool_1d(x, chance=1, outof=2)
    throw Exception.new("chance must be less than outof") if chance >= outof
    get_perlin_int_1d(x, 1, outof) <= chance
  end

  def get_perlin_bool_2d(x, y, chance=1, outof=2)
    throw Exception.new("chance must be less than outof") if chance >= outof
    get_perlin_int_2d(x, y, 1, outof) <= chance
  end

  def get_perlin_bool_3d(x, y, z, chance=1, outof=2)
    throw Exception.new("chance must be less than outof") if chance >= outof
    get_perlin_int_3d(x, y, z, 1, outof) <= chance
  end

  #pulls a random item out of an array using the perlin generator
  def get_perlin_item_1d(x, array)
    array[get_perlin_int_1d(x, 0, array.length-1)]
  end

  def get_perlin_item_2d(x, y, array)
    array[get_perlin_int_2d(x, y, 0, array.length-1)]
  end

  def get_perlin_item_3d(x, y, z, array)
    array[get_perlin_int_3d(x, y, z, 0, array.length-1)]
  end
end