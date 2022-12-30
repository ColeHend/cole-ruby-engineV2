require_relative "battle/battle_core.rb"
require_relative "./actionController/action_core.rb"
require_relative "event_core.rb"
class Event_NPC < Event_Core
    attr_accessor :stats, :object, :moveType, :targetObject
    include Animate
    def initialize(mapNumber,eventName,x,y,activateType,currPage,activateEvent,imgName,bbHeight,bbWidth,facing="downStop")
        super(mapNumber,eventName,x,y,activateType,currPage,activateEvent,imgName,4,4,bbHeight,bbWidth)
        @stats = Battle_Core.new(eventName)
        @moveType = "follow" # "follow" or "random" or "none"
        @targetObject = $scene_manager.scenes["player"] # need a target to "follow"
        @facing = facing
        @object = GameObject.new(self.x,self.y,self.w,self.h,self.imgName,nil,self.columns,self.rows)
        # puts($scene_manager.allMaps[mapNumber-1].mWidth)
        @moveController = Move_NPC.new(@object,@moveType,self.sprite,self.mapNumber)
        @nature = "neutral"
        @detectRange = 3*32
        @actionController = Action_Core.new(@object,@stats,@moveType,@targetObject,@detectRange,@nature)    
    end
    def easy_move_set()
       if @moveType == "follow"
        @moveController.set_move($scene_manager.scenes["player"],@facing,self)
       else
        @moveController.set_move()
       end
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
        easy_move_set()
        # creates a path for the npc to move to
        @moveController.update()
    end
    def draw
        # executes the move path for the npc
        @moveController.draw()
        @actionController.draw()
    end
end