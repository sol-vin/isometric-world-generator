# simple method additions for useful features.

class Array
  class << self
    def make_2d_array(size_x, size_y, default = nil)
      array = []
      size_x.times do |x|
        array << []
        size_y.times do |y|
          array[x] << []
          array[x][y] = default
        end
      end
      array
    end

    def make_3d_array(size_x, size_y, size_z, default = nil)
      array = []
      size_x.times do |x|
        array << []
        size_y.times do |y|
          array[x] << []
          size_z.times do |z|
            array[x][y] << []
            array[x][y][z] = default
          end
        end
      end
      array
    end
  end
end

class Hash
  #take keys of hash and transform those to a symbols
  def self.keys_to_sym(value)
    return value unless value.is_a?(Hash)
    hash = value.inject({}){|memo,(k,v)| memo[k.to_sym] = Hash.keys_to_sym(v); memo}
    return hash
  end
end


#Monkey patch numeric to be useful
class Numeric
  def clamp min, max
    [[self, max].min, min].max
  end
end

class String
  def to_bool
    return true   if self =~ (/(true|t|yes|y|1)$/i)
    return false  if self.blank? || self =~ (/(false|f|no|n|0)$/i)
    raise ArgumentError.new("invalid value for Boolean: \"#{self}\"")
  end
end