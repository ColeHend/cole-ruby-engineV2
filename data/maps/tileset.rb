require "json"
class Tileset
    def initialize(imgName="CastleTown",columns=8,rows=23)
        @tilesetName = imgName
        @tilesetIMG = GameObject.new(0,0,0,0,@tilesetName,nil,columns,rows)
        @impassableTiles = Array.new #Block.new(x,y,w,h)
    end
    def addImpass(x,y)
        @impassableTiles.push(Block.new(x,y,32,32))
    end
    def isntPassable(tileNum)
        passMap = JSON.load(File.read("passability/#{@tilesetName}.json"))
        return passMap["collidable"].include?(tileNum)
    end
    def draw_tile(tile,y,x)
        @tilesetIMG.set_animation(tile)
        @tilesetIMG.x = x*32
        @tilesetIMG.y = y*32
        @tilesetIMG.draw()
        if isntPassable(tile) == true
            addImpass(x*32,y*32)
        end
    end
    def update
    end

    def draw
    end
end