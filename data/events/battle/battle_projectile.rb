require_relative "../event_core.rb"
class Battle_Projectile < Event_Core
    include Animate
    def initialize(mapNumber,eventName,x,y,onHit,imgName,rangeMod,speedMod,damage,bbHeight=32,bbWidth=46)
        super(mapNumber,eventName,x,y,"touch",0,onHit,imgName,4,4,bbHeight,bbWidth)
        @object = GameObject.new(self.x,self.y,self.w,self.h,self.imgName,nil,self.columns,self.rows)
        @moveController = Move_NPC.new(@object,@moveType)
        @rangeMod = rangeMod
        @damage = damage
        @speedMod = speedMod
    end
    def move_self(dir,range,speed=6)
        range.times{
            @moveController.move(dir,speed)
        }
    end
    def update
        @moveController.update()
    end
    def draw
        @moveController.draw()
    end
end