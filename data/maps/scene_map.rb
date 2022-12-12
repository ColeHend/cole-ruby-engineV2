class Scene_Map
    def initialize
        @currentMap
        @mWidth = @currentMap.width 
        @mHeight = @currentMap.height  
        
    end
    def update
        @currentMap.map.update()
    end
    def draw
        @currentMap.map.draw()
    end
end