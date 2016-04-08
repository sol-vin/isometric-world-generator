class IsometricAssets
  attr_reader :texture
  attr_reader :assets, :alias, :collections


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

  def open_content(name)
    # find all files from content directory
    Dir.entries(content_path + "#{assets_name}/").each do |block_asset|
      next if block_asset =~ /^\.*$/ #Returns . and . .as folders smh
      name = block_asset.to_sym
      puts "loading #{assets_name}/#{block_asset}"

      #try to assign images if they exist
      blocks_path = content_path + "#{assets_name}/" + "#{block_asset}/"

      #Load in each image and load into an array. assets[x][y]
      #combine images on one spritesheet in the root assets_name directory
      # should make two files
      #   - texture_config.yml
      #   - texture.png
    end
    # stitch them into a single texture
    # create source rect information for retrieval
  end

  def read_texture_config(file)
    #read the texture config files in (YAML)
  end

  def [] asset_name
    @assets[asset_name]
  end

end