class Scene_Manager
    attr_accessor :windowskin, :currentScene, :input
    def initialize
        @windowskin = "fancyWindowSkin"
        @scenes = Hash.new
        @input = Input.new
        @windowskins = []
        @tilesets = []
        @startScenes = [["titlescreen",TitleScreen.new()],["map",Scene_Map.new()]]
        @startWindowSkins = ["fancyWindowSkin","earthboundWindowSkin","blackWindowSkin"]
        @startTilesets = [["CastleTownTileset",:CastleTown,8,23]]
    end
    def startUp(startScenes=@startScenes,startWindowSkins=@startWindowSkins,startTilesets=@startTilesets)
        startScenes.each{|scene|
            $scene_manager.scenes[scene[0]] = scene[1]
        }
        startWindowSkins.each{|windowskin|
            @windowskins.push(GameObject.new(0,0,0,0,windowskin,nil,6,4))
        }
        startTilesets.each{|tileset|
            @tilesets.push(Game_Object.new(tileset[0],0,0,0,0,tileset[1],nil,tileset[2],tileset[3]))
        }
    end
    def setScene(sceneName)
        @currentScene = @scenes[sceneName]
    end
    def update
        @currentScene.update()
    end
    def draw
        @currentScene.draw()
    end
end