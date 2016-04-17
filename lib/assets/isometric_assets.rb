require 'rmagick'
require 'gosu'

class IsometricAssets
  attr_reader :block_texture, :tile_texture, :config
  attr_reader :assets, :alias, :collections
  attr_reader :block_width, :block_height
  attr_reader :tile_width, :block_width

  def initialize(name)
    @assets = {}
    @alias = {}

    open_content name
  end

  def home_path
    File.absolute_path(File.dirname(File.absolute_path(__FILE__ )) + '/../../')
  end

  def content_path
    home_path  + "/content/"
  end

  def cache_path
    home_path + "/cache/"
  end

  def saves_path
    home_path + "/saves/"
  end

  def open_content(assets_name)
    asset_path = content_path + "#{assets_name}/"
    texture_path = asset_path + "texture.png"
    texture_config_path = asset_path + "config.yml"

    @config = read_texture_config(texture_config_path)


    assets_col_to_stitch = []
    current_col = 0

    # find all files from content directory
    Dir.entries(asset_path).each do |block_asset|
      next if block_asset =~ /^\.*$/ #Returns . and . .as folders
      block_asset_name = block_asset.to_sym
      puts "loading #{assets_name}/#{block_asset}"

      #try to assign images if they exist
      blocks_path = asset_path + "#{block_asset}/"
      block_config_path = blocks_path + "config.yml"

      assets_row_to_stitch = []
      current_row = 0

      assets[block_asset_name] = IsometricAsset.new(self, block_asset_name)
      assets[block_asset_name].read_config(block_config_path)

      Dir.entries(blocks_path).each do |asset_file|
        next if asset_file =~ /^\.*$/ #Returns . and . .as folders
        next if asset_file == "config.yml"
        next unless asset_file =~ /\.png$/

        asset_tag = asset_file.split(?.)[0].to_sym
        assets[block_asset_name][asset_tag] = [current_row, current_col]
        assets_row_to_stitch << blocks_path + asset_file

        current_row += 1
      end
      assets_col_to_stitch << assets_row_to_stitch
      current_col += 1
    end

    TextureStitcher.stitch(assets_col_to_stitch).write(texture_path)

    @block_texture = Gosu::Image.load_tiles(block_texture_path, config[:block_height], config[:block_width], retro: true)
    @block_texture = Gosu::Image.load_tiles(block_texture_path, config[:block_height], config[:block_width], retro: true)
  end

  def read_texture_config(config_yml)
    #read the texture config files in (YAML)
    file = File.open(config_yml, "r")
    yaml_dump = Hash.keys_to_sym YAML.load(file.read)
    file.close
    @config = yaml_dump

  end

  def [] asset_name
    @assets[asset_name]
  end

  def add_alias(key, asset)
    @alias[key] = asset
  end

  def remove_alias(key)
    @alias[key] = nil
  end

  def draw_tile(tile, position)

  end

  def draw_block(block, position)

  end
end