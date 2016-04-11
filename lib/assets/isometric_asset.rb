class IsometricAsset
  attr_reader :config
  attr_reader :tags
  attr_reader :name
  attr_reader :parent

  def initialize(parent, name, tags = {})
    @parent = parent
    @name = name
    @tags = tags
    @config = {}
  end

  def read_config(config_yml)
    #read the texture config files in (YAML)
    file = File.open(filename, "r")
    yaml_dump = Hash.keys_to_sym YAML.load(file.read)
    file.close
    @config = yaml_dump
  end
end