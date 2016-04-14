require 'yaml'

class IsometricAsset
  attr_reader :config
  attr_reader :tags
  attr_reader :name
  attr_reader :parent

  def initialize(parent, name)
    @parent = parent
    @name = name
    @tags = {}
    @config = {}
  end

  def read_config(config_yml)
    #read the texture config files in (YAML)
    file = File.open(config_yml, "r")
    yaml_dump = Hash.keys_to_sym YAML.load(file.read)
    file.close
    @config = yaml_dump
  end

  def [] tag
    tags[tag]
  end

  def []= tag, item
    tags[tag] = item
  end

  def draw_asset(x, y, color, view, rotation = :none)
    return :no_layer if config[:views][view][rotation].nil?

    config[:views][view][rotation].each do |asset_tag, asset_options|
      # the color of the object as provided the config, or at runtime,
      # config overrides the color passed into this method via arguments
      # this is to prevent specially colored objects from taking color properties
      # if you specify a color in the cfg.yml for this asset, it will override the color
      # passed in by argument color.

      real_color = (asset_options[:color] ? asset_options[:color] : color)

      # the scale of the object
      # flip values (flip_h, flip_v) are xor'd with the flip value passed in by the config
      # TODO: Make flip decisions for non symetrical objects. that need to have bases 16 for each rotation and view
      scale_h = (flip_h ^ asset_options[:flip_h] ? -1.0 : 1.0)
      scale_v = (flip_v ^ asset_options[:flip_v] ? -1.0 : 1.0)

      # positional correction for the flip
      pcx = (flip_h ^ asset_options[:flip_h] ? width : 0)
      pcy = (flip_v ^ asset_options[:flip_v] ? height : 0)

      #Access the asset and draw it
      parent[name][asset_tag].draw(x + pcx, y + pcy, 1, scale_h, scale_v, real_color)
    end
  end
end