class Map01 < Map_Base
    def initialize()
        super(Tileset.new("CastleTown",8,23),30,20,JSON.parse(File.read(File.expand_path("./data/maps/map01.json"))),5)
        self.events = [
            Event_NPC.new(1,"Event101",15*32,2*32,"action",0,[->(){}],"ghost",46,31,"downStop"),
            Event_NPC.new(1,"Event102",3*32,15*32,"action",0,[->(){}],"greenMan",46,31,"downStop")
        ]
        
    end
    def event_updates()
        ev1 = self.events[0]
        ev2 = self.events[1]
        player = $scene_manager.scenes["player"]
        #------------------------
        # Event 101 | ghost
        #------------------------
        # ev1.set_none()
        ev1.set_follow(ev2)

        #------------------------
        # Event 102 | greenMan
        #------------------------  
        #ev2.set_none()
        ev2.set_follow(player)
    end
    def update
        super
        event_updates()
    end
    def draw
        super
    end
end