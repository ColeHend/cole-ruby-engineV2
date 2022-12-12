require_relative "../../events/move_collision.rb"
require_relative "../../events/movement_control.rb"
require_relative "../../../files/animate.rb"
 
class Spell
    include Animate
    attr_accessor :name, :range, :eventBase, :stability, :animName, :cooldown, :element, :damage, :target, :spellType, :triggered
    def initialize(name,range,eventBase,stability,spellType,animName,cooldown,int=12)
        @name = name # "firebolt"
        @range = range # 5*32
        @stability = Battle_Core.new(stability[0],stability[1]) # ["Firebolt",1]
        @animName = animName # "fire"
        @element = element # "fire"
        @damage = damage # 2
        @cooldown = cooldown # 750
        @spellType = spellType # "projectile"
        @spellEffect = effect(spellType) 
        @int = int
        @eventBase = eventBase #
        @target = target #
        @triggered = false
    end
    def effect(type)
        case type
        when "projectile"
            collisionDetect = MoveCollision.new
          return ->(){
                defender = collisionDetect.check_collision(@eventBase,8,true)
                if defender.is_a?(Event)
                    damage = FightCenter.new("damage",defender).magicDamage_calc(@damage,@stability.getMod(@int),defender.battle.mRes)
                    @animation.play_animation(@animName,(defender.x - 86) ,(defender.y - 86) ,nil)
                    puts("#{@name} hit!")
                    defender = defender.battle
                    defender.currentHP -= damage
                else
                    @animation.play_animation(animName,(object.x - 96) ,(object.y - 96),nil)
                    puts("#{@name} miss!")
                end
                @stability.currentHP = 0
            }
        when "autoEffect"
            return ->(){}
        else
            puts("Invalid spell type!")
        end
    end
    def ranged_shot(facing)
        range = @range/4
        u = 0
        Thread.new{
            collisionDetect = MoveCollision.new
            until u > range do
                @moveControl.Move(@eventBase.vector,@eventBase,facing,1,4)
                if collisionDetect.check_collision(@eventBase,0) == true
                    @spellEffect.call
                    break
                elsif collisionDetect.check_collision(@eventBase,0) != true && u == range
                    @spellEffect.call
                    break
                end
                u += 1
            end
        }
    end
    def cast(facing="up")
        case @spellType
        when "projectile"
            dist = 2
            @animation.play_animation(@animName,(@eventBase.x - 86) ,(@eventBase.y - 86) ,nil)
            draw_character(@eventBase, (facing) ,1)
            case facing
            when "up"
                @eventBase.y -= (@eventBase.h+dist)
                $scene_manager.scene["map"].currentMap.events.push(self)
                ranged_shot("up")
            when "down"
                @eventBase.y += (@eventBase.h+dist)
                $scene_manager.scene["map"].currentMap.events.push(self)
                ranged_shot("down")
            when "left"
                @eventBase.x -= (@eventBase.w+dist)
                $scene_manager.scene["map"].currentMap.events.push(self)
                ranged_shot("left")
            when "right"
                @eventBase.x += (@eventBase.w+dist)
                $scene_manager.scene["map"].currentMap.events.push(self)
                ranged_shot("right")
            end
        when "autoEffect"
    end
    def update
        if @eventBase != nil
            @eventBase.update()
        end
    end
    def draw
        if @eventBase != nil
            @eventBase.draw()
        end
end
