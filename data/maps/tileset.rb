require "json"
class Tileset
    attr_accessor :impassableTiles, :tilesetIMG, :tilesetName
    def initialize(imgName="CastleTown",columns=8,rows=23)
        @tilesetName = imgName
        @tilesetIMG = GameObject.new(0,0,0,0,@tilesetName,nil,columns,rows)
        @impassableTiles = Array.new #Block.new(x,y,w,h)
        impassArr = JSON.parse(File.read(File.expand_path("./data/maps/passability/#{@tilesetName}.json")))
        @impassTileArr = impassArr['collidable']

    end
    def addImpass(x,y)
        @impassableTiles.push(Block.new(x,y,30,24))
    end
    def isntPassable(tileNum)
        return @impassTileArr.include?(tileNum)
    end
    def draw_tile(tile,x,y)
        @tilesetIMG.set_animation(tile)
        @tilesetIMG.x = x*32
        @tilesetIMG.y = y*32
        @tilesetIMG.draw()
        
    end
    def add_impass(tile,x,y)
        if isntPassable(tile) == true
            # puts("impass added!")
            addImpass(x*32,y*32)
        end
    end
    def update
    end

    def draw
    end
end