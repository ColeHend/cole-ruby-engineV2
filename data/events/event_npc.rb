require_relative "battle/battle_core.rb"
require_relative "event_core.rb"
class Event_NPC < Event_Core
    attr_accessor :stats, :object, :moveType, :targetObject
    include Animate
    def initialize(mapNumber,eventName,x,y,activateType,currPage,activateEvent,imgName,bbHeight,bbWidth,facing="downStop")
        super(mapNumber,eventName,x,y,activateType,currPage,activateEvent,imgName,4,4,bbHeight,bbWidth)
        @stats = Battle_Core.new(eventName)
        @moveType = "random" # "follow" or "random" or "none"
        @targetObject = nil # need a target to "follow"
        @facing = facing
        @object = GameObject.new(self.x,self.y,self.w,self.h,self.imgName,nil,self.columns,self.rows)
        @moveController = Move_NPC.new(@object,@moveType)
            
    end
    def easy_move_set()
        case @moveType
        when "random"
            @moveController.set_move()
        when "follow"
            if @targetObject != nil # for follow
                @moveController.set_move(@targetObject,@facing)
            end
        when "none"
            @moveController.set_move()
        else
            
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
        # makes sure the @moveType is set right in the @moveController
        easy_move_set()
        # creates a path for the npc to move to
        @moveController.update()
    end
    def draw
        # executes the move path for the npc
        @moveController.draw()
    end
end