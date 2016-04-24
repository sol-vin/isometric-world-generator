class IsometricWorlds
  @worlds = {}
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
  end
end