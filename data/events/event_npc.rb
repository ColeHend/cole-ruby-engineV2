require_relative "battle/battle_core.rb"
require_relative "./actionController/action_core.rb"
require_relative "event_core.rb"
class Event_NPC < Event_Core
    attr_accessor :stats, :object
    attr_reader :moveType, :targetObject
    include Animate
    def initialize(mapNumber,eventName,x,y,activateType,currPage,activateEvent,imgName,bbHeight,bbWidth,facing="downStop")
        super(mapNumber,eventName,x,y,activateType,currPage,activateEvent,imgName,4,4,bbHeight,bbWidth)
        @stats = Battle_Core.new(eventName)
        @moveType = "none" # "follow" or "random" or "none"
        @targetObject = $scene_manager.scenes["player"] # need a target to "follow"
        @facing = facing
        @object = GameObject.new(self.x,self.y,self.w,self.h,self.imgName,nil,self.columns,self.rows)
        # puts($scene_manager.allMaps[mapNumber-1].mWidth)
        @sprite = self.sprite
        @moveController = Move_NPC.new(@object,@moveType,@sprite,self.mapNumber)
        @nature = "neutral"
        @detectRange = 3*32
        @actionController = Action_Core.new(@object,@stats,@moveType,@targetObject,@detectRange,@nature)    
    end
    def set_none()
        @moveType = "none"
    end
    def set_random()
        @moveType = "random"
    end
    def set_follow(object)
        @moveType = "follow"
        @targetObject = object
    end
    def setMoveAttack(distance,objectOfFocus,atkType)
        if @eventObject.w != nil || @eventObject.h != nil
            @facing
            focus(dist,objectOfFocus)
            @fightControl.eventAtkChoice(@self,@battle,@facing,dist,focus(dist,objectOfFocus),atkType) #  <- Starts its attack logic
          end
    end
    def update
        super
        @actionController.update()
        # makes sure the @moveType is set right in the @moveController
        @moveController.update_move(self)
        @moveController.update()
        # creates a path for the npc to move to
    end
    def draw
        # executes the move path for the npc
        @moveController.draw()
        @actionController.draw()
    end
end