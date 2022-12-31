class Scene_Map
    attr_accessor :runEffects, :allMaps, :currentMap, :mWidth, :mHeight
    def initialize
        @allMaps = [Map01.new,Map02.new]
        @currentMap = @allMaps[0]
        @mWidth = @currentMap.w
        @mHeight = @currentMap.h 
        
    end
    def update
        @currentMap.update()
        
    end
    def draw
        @currentMap.draw()
        
    end
end