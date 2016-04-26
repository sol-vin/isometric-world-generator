class IsometricWorlds
  class << self
    def [] world_name
      @worlds[world_name]
    end

    def []= world_name, value
      @worlds[world_name] = value
    end

    def delete(world_name)
      @worlds.delete world_name
    end

    def world_names
      @worlds.keys
    end

    def count
      @worlds.count
    end

    def clear
      @worlds = {}
    end
  end

  self.clear

  def initialize()
    clear
  end

  def [] world_name
    @worlds[world_name]
  end

  def []= world_name, value
    @worlds[world_name] = value
  end

  def delete(world_name)
    @worlds.delete world_name
  end

  def world_names
    @worlds.keys
  end

  def count
    @worlds.count
  end

  def clear
    @worlds = {}
  end
end