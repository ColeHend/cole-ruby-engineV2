class Map01 < Map_Base
    def initialize()
        super(Tileset.new("CastleTown",8,23),30,20,JSON.parse(File.read(File.expand_path("./data/maps/map01.json"))),5)
        self.events = [
            Event_NPC.new(1,"Event101",15*32,2*32,"action",0,[->(){}],"ghost",46,31,"downStop")
        ]
    end
    def update
        super
    end
    def draw
        super
    end
end