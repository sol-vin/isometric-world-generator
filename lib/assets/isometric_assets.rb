require 'rmagick'
require 'gosu'

require_relative './isometric_asset'
require_relative './texture_stitcher'
require_relative '../monkey_patch'

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
    tiles_asset_path = asset_path + "tiles/"
    blocks_asset_path = asset_path + "blocks/"

    tile_texture_path = tiles_asset_path + "tiles.png"
    block_texture_path = blocks_asset_path + "blocks.png"

    texture_config_path = asset_path + "config.yml"

    @config = read_texture_config(texture_config_path)

    TextureStitcher.stitch(combine_texture_files(:tiles, tiles_asset_path)).write(tile_texture_path)
    TextureStitcher.stitch(combine_texture_files(:block, blocks_asset_path)).write(block_texture_path)

    @block_texture = Gosu::Image.load_tiles(block_texture_path, config[:block_height], config[:block_width], retro: true)
    @tile_texture = Gosu::Image.load_tiles(tile_texture_path, config[:tile_height], config[:tile_width], retro: true)
  end

  def combine_texture_files(type, type_asset_path)
    assets_col_to_stitch = []
    current_col = 0

    # find all files from content directory
    Dir.entries(type_asset_path).each do |asset_name|
      next if asset_name =~ /^\.*$/ #Returns . and . .as folders so we skip

      asset_name = asset_name.to_sym
      puts "loading /#{type}/#{asset_name}"

      #try to assign images if they exist
      asset_path = type_asset_path + "#{asset_name}/"
      asset_config_path = asset_path + "config.yml"

      assets_row_to_stitch = []
      current_row = 0

      assets[type][asset_name] = IsometricAsset.new(self, asset_name)
      assets[type][asset_name].read_config(asset_config_path)

      Dir.entries(asset_path).each do |asset_file|
        next if asset_file =~ /^\.*$/ #Returns . and . .as folders
        next if asset_file == "config.yml"
        next unless asset_file =~ /\.png$/

        asset_tag = asset_file.split(?.)[0].to_sym
        assets[type][asset_name][asset_tag] = Vector2.new(current_row, current_col)
        assets_row_to_stitch << asset_path + asset_file

        current_row += 1
      end
      assets_col_to_stitch << assets_row_to_stitch
      current_col += 1
    end

    assets_col_to_stitch
  end

  def read_texture_config(config_yml)
    #read the texture config files in (YAML)
    file = File.open(config_yml, "r")
    yaml_dump = Hash.keys_to_sym YAML.load(file.read)
    file.close
    @config = yaml_dump
  end

  def [] type
    if :blocks
      blocks
    elsif :tiles
      tiles
    else
      fail
    end
  end

  def add_alias(key, asset)
    @alias[key] = asset
  end

  def remove_alias(key)
    @alias[key] = nil
  end
end