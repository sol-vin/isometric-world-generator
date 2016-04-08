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
    return true   if self == true   || self =~ (/(true|t|yes|y|1)$/i)
    return false  if self == false  || self.blank? || self =~ (/(false|f|no|n|0)$/i)
    raise ArgumentError.new("invalid value for Boolean: \"#{self}\"")
  end
end