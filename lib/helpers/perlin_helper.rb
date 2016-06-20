require 'perlin'

module PerlinHelper
  attr_reader :perlin_step
  attr_reader :perlin_octave
  attr_reader :perlin_persist
  attr_reader :perlin_x_offset
  attr_reader :perlin_y_offset
  attr_reader :perlin_z_offset


  DEFAULTS = {
    perlin_step: 0.123456789,
    perlin_octave: 1,
    perlin_persist: 0.2,
    perlin_x_offset: 0,
    perlin_y_offset: 0,
    perlin_z_offset: 0
  }

  attr_reader :seed
  attr_accessor :max_height

  def make(seed, **options)
    if options.count.zero?
      parse_options_hash DEFAULTS
      self.seed = seed
    else
      defaults = DEFAULTS.clone
      defaults.merge! options
      parse_options_hash defaults
      self.seed = seed
    end
  end

  def parse_options_hash(options)
    @perlin_step = options[:perlin_step]
    @perlin_octave = options[:perlin_octave]
    @perlin_persist = options[:perlin_persist]
    @perlin_x_offset = options[:perlin_x_offset]
    @perlin_y_offset = options[:perlin_y_offset]
    @perlin_z_offset = options[:perlin_z_offset]
  end

  def seed=(value)
    @seed = value
    @perlin_noise = Perlin::Generator.new(seed, perlin_persist, perlin_octave)
    @perlin_noise.classic = true
  end


  def get_perlin_height(x, y)
    (get_perlin_noise(x, y) +  1.0/2.0) * max_height
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
    @perlin_noise[(x + perlin_x_offset) * perlin_step, perlin_z_offset]
  end

  def get_perlin_noise_2d(x, y)
    @perlin_noise[(x + perlin_x_offset) * perlin_step, (y + perlin_y_offset) * perlin_step]
  end

  def get_perlin_noise_3d(x, y, z)
    @perlin_noise[(x + perlin_x_offset) * perlin_step, (y + perlin_y_offset) * perlin_step, (z + perlin_z_offset) * perlin_step]
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
    (get_perlin_noise_1d(x).to_s.split(?.).last.to_i % (high+1 -low)) + low
  end

  def get_perlin_int_2d(x, y, low, high)
    throw Exception.new("start must be less than end!") if low >= high
    (get_perlin_noise_2d(x,y).to_s.split(?.).last.to_i % (high+1 -low)) + low
  end

  def get_perlin_int_3d(x, y, z, low, high)
    throw Exception.new("start must be less than end!") if low >= high
    (get_perlin_noise_3d(x,y,z).to_s.split(?.).last.to_i % (high+1 -low)) + low
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
    (get_perlin_noise_1d(x).to_s.split(?.).last.prepend('.').to_f % (high-low)) + low
  end

  def get_perlin_float_2d(x, y, low, high)
    throw Exception.new("start must be less than end!") if low >= high
    (get_perlin_noise_2d(x,y).to_s.split(?.).last.prepend('.').to_f % (high-low)) + low
  end

  def get_perlin_float_3d(x, y, z, low, high)
    throw Exception.new("start must be less than end!") if low >= high
    (get_perlin_noise_3d(x,y,z).to_s.split(?.).last.prepend('.').to_f % (high-low)) + low
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