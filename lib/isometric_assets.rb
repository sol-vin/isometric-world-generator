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
    # stitch them into a single texture
    # create source rect information for retrieval
  end

  def [] asset_name
    @assets[asset_name]
  end

end