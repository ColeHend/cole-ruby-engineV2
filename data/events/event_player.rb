require_relative "battle/battle_core.rb"
require_relative "event_core.rb"
class Event_Player < Event_Core
    def initialize(mapNumber,eventName,x,y,activateType,currPage,activateEvent,imgName,bbHeight,bbWidth)
        super(mapNumber,eventName,x,y,activateType,currPage,activateEvent,imgName,4,4,bbHeight,bbWidth)
        @object = GameObject.new(self.x,self.y,self.bbWidth,self.bbHeight,self.imgName,nil,self.columns,self.rows)
        @facing = "down"
        @moveControl = Move_Controller.new(@object,@facing)
        @stats = Battle_Core.new(eventName)
    end
    
    def update
        @moveControl.update()
    end
    def draw
        @moveControl.draw()
    end
end