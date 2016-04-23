require 'rmagick'
require 'gosu'

require_relative './isometric_asset'
require_relative './texture_stitcher'
require_relative '../data/vector'
require_relative '../monkey_patch'

class IsometricAssets
  attr_reader :block_texture, :tile_texture, :config
  attr_reader :assets, :collections
  attr_reader :block_width, :block_height
  attr_reader :tile_width, :block_width

  def initialize(name)
    @assets = {blocks: {}, tiles: {}}

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

    tile_texture_path = asset_path + "tiles.png"
    block_texture_path = asset_path + "blocks.png"

    texture_config_path = asset_path + "config.yml"

    @config = read_texture_config(texture_config_path)

    TextureStitcher.stitch(combine_texture_files(:tiles, tiles_asset_path)).write(tile_texture_path)
    TextureStitcher.stitch(combine_texture_files(:blocks, blocks_asset_path)).write(block_texture_path)

    @block_texture = Gosu::Image.new(block_texture_path)
    @tile_texture = Gosu::Image.new(tile_texture_path)
  end

  def combine_texture_files(type, type_asset_path)
    assets_col_to_stitch = []
    current_col = 0

    # find all files from content directory
    Dir.entries(type_asset_path).each do |asset_name|
      next if asset_name =~ /^\.*$/ #Returns . and . .as folders
      next if asset_name == "config.yml"
      next unless File.directory?(type_asset_path + asset_name)


      asset_name = asset_name.to_sym
      puts "loading /#{type}/#{asset_name}"

      #try to assign images if they exist
      asset_path = type_asset_path + "#{asset_name}/"
      asset_config_path = asset_path + "config.yml"

      next unless File.exist?(asset_config_path)

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
    if type == :blocks
      blocks
    elsif type == :tiles
      tiles
    else
      fail
    end
  end

  def draw_tile(tile, view, position)
    tile_asset = self[:tiles][tile.type]
    tile_asset.draw_asset(position.x,  position.y, tile.color, view, tile.rotation)
  end

  def draw_block(block, view, position)
    block_asset = self[:blocks][block.type]
    block_asset.draw_asset(position.x,  position.y, block.color, view, block.rotation)
  end
end