class Map01 < Map_Base
    def initialize()
        super(Tileset.new("CastleTown",8,23),30,20,JSON.parse(File.read(File.expand_path("./data/maps/map01.json"))),5)
        @events = [
            Event_NPC.new(1,"Event101",5*32,5*32,"action",0,[->(){}],"charizard",46,32,"downStop")
        ]
    end
    def update
        super
    end
    def draw
        super
    end
end