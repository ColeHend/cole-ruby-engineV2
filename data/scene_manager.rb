require_relative "./events/moveController/move_star.rb"
require_relative "./events/event_player.rb"
require "json"
class Scene_Manager
    attr_accessor :tilesets, :maps, :windowskin, :currentScene, :input,:theEffects,:scenes
    attr_reader :allPaths, :currentMap
    def initialize
        @windowskin = "fancyWindowSkin"
        @scenes = Hash.new
        @input = Input.new
        @windowskins = Hash.new
        @tilesets = Hash.new
        @maps = []
        @currentScene
        @animations = JSON.parse(File.read(File.expand_path('./data/animation.json')))
        @allPaths = Hash.new
        
        @startWindowSkins = ["fancyWindowSkin","earthboundWindowSkin","blackWindowSkin"]
        @startTilesets = [["CastleTownTileset",:CastleTown,8,23]]
    end
    def startUp(startScenes=@startScenes,startWindowSkins=@startWindowSkins,startTilesets=@startTilesets)
        puts("starting Up..")
        startWindowSkins.each{|windowskin|
            puts("  loading #{windowskin} windowskin...")
            @windowskins[windowskin] = GameObject.new(0,0,0,0,windowskin,nil,6,4)
        }
        startTilesets.each{|tileset|
            puts("  loading #{tileset[0]} tileset...")
            @tilesets[tileset[0]] = GameObject.new(0,0,0,0,tileset[1],nil,tileset[2],tileset[3])
        }
        #Loading Scenes
        puts("loading scenes...")
        puts("  loading titlescreen scene...")
        $scene_manager.scenes["titlescreen"] = TitleScreen.new()
        puts("  loading map scene...")
        $scene_manager.scenes["map"] = Scene_Map.new()
        puts("done loading!")
        @currentMap = $scene_manager.scenes["map"].currentMap
        @maps = $scene_manager.scenes["map"].allMaps

        #Pathfinding Calculations
        puts("calculating paths..")
        starPathDir = File.expand_path("./data/events/moveController/path_star.json")
        if !File.exist?(starPathDir)
            file = File.new(starPathDir, 'w')
            @allPaths = AStar.check_maps(@maps)
            theHash = Hash["paths" => @allPaths]
            file.syswrite(theHash.to_json)
            file.close()
            # File.write(starPathDir,)
            
        else
            pathJSON = JSON.parse(File.read(starPathDir))
            @allPaths = pathJSON["paths"]
        end
        puts("done calculating.")
        puts("----------------------------------------")
    end
    def getEffects(animationName,x,y)
        @animations.each{|anim|
            if anim.animationName == animationName
               return [
                   Effect.new(x-(anim.xOff[0]*32), y-(anim.yOff[0]*32), anim.imgName, anim.row, anim.col, anim.interv, anim.frames,nil,anim.sound,anim.soundExt,nil),#up
                   Effect.new(x-(anim.xOff[1]*32), y-(anim.yOff[1]*32), anim.imgName, anim.row, anim.col, anim.interv, anim.frames,nil,anim.sound,anim.soundExt,:vert),#down
                   Effect.new(x-(anim.xOff[2]*32), y-(anim.yOff[2]*32), anim.imgName, anim.row, anim.col, anim.interv, anim.frames,nil,anim.sound,anim.soundExt,nil),#left
                   Effect.new(x-(anim.xOff[3]*32), y-(anim.yOff[3]*32), anim.imgName, anim.row, anim.col, anim.interv, anim.frames,nil,anim.sound,anim.soundExt,:horiz)#right
               ]
                
            end
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