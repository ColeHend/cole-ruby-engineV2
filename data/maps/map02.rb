class Map02 < Map_Base
    def initialize()
        super(Tileset.new("mountainTileset",8,23),41,31,JSON.parse(File.read(File.expand_path("./data/maps/map02.json"))),5)
        self.events = [
            Event_NPC.new(1,"Event201",15*32,2*32,"action",0,[->(){}],"ghost",46,31,"downStop"),
            Event_NPC.new(1,"Event202",3*32,15*32,"action",0,[->(){}],"greenMan",46,31,"downStop")
        ]
        
    end
    def event_updates()
        ev1 = self.events[0]
        ev2 = self.events[1]
        player = $scene_manager.scenes["player"]
        #------------------------
        # Event 201 | ghost
        #------------------------
        # ev1.set_none()
        ev1.set_follow(ev2)

        #------------------------
        # Event 202 | greenMan
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