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
end