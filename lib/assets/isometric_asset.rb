class IsometricAsset
  attr_reader :config
  attr_reader :tags
  attr_reader :name
  attr_reader :parent

  def initialize(parent, name, tags = {})
    @parent = parent
    @name = name
    @tags = tags
  end

  def read_config(config_yml)

  end
end