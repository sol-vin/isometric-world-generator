require 'rmagick'

class IsometricAssets
  attr_reader :texture
  attr_reader :assets, :alias, :collections
  attr_reader :block_width, :block_height

  def initialize(name)
    @assets = {}
    @alias = {}

    open_content name
  end

  def home_path
    File.dirname("../" + File.absolute_path(__FILE__))
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

      block_config = read_texture_config(block_config_path)

      assets_row_to_stitch = []
      current_row = 0

      assets[block_asset_name] = IsometricAsset.new(self, block_asset_name)

      Dir.entries(blocks_path).each do |asset_file|
        next if block_asset =~ /^\.*$/ #Returns . and . .as folders
        next if asset_file == "config.yml"

        asset_tag = asset_file.split(?.)[0].to_sym
        assets[block_asset_name][tag] = [current_row, current_col]
        assets_row_to_stitch << blocks_path + asset_file

        current_row += 1
      end
      assets_col_to_stitch << assets_row_to_stitch
      current_col += 1
    end
    #TextureStitcher.stitch(assets_col_to_stitch)
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
end