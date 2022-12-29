class Battle_System
    def initialize(actionObject,range,facing)
        @actionObject = actionObject
        @detection = MoveCollision.new(actionObject)
        @facing = facing
        @detectRange = range
        @evtRangeQueen = @detection.check_range(@detectRange,true)
        @evtRangeRook = @detection.check_surrounding("all",@detectRange)
        
    end
    def strike_melee(evtCheck,indexDir,animationName,damage)
        myEffects = $scene_manager.getEffects(animationName,@actionObject.x,@actionObject.y)
        if evtCheck.length > 0
            evtCheck.each{|evt|
                evt.stats.currentHP -= damage
            }
            $scene_manager.currentMap.runEffects.push(myEffects[indexDir])
        else
            $scene_manager.currentMap.runEffects.push(myEffects[indexDir])
        end
    end
    
    def strike_ranged(projectile,weapon)
        strikeRange = projectile.rangeMod + weapon.range
        stikeSpeed = projectile.speedMod + weapon.speed
        strikeDamage = projectile.damage + weapon.damage
        case @facing
        when "up"
            projectile.x = @actionObject.x - 32
            projectile.y = @actionObject.y 
        when "down"
            projectile.x = @actionObject.x + 32
            projectile.y = @actionObject.y
        when "left"
            projectile.x = @actionObject.x
            projectile.y = @actionObject.y - 32
        when "right"
            projectile.x = @actionObject.x
            projectile.y = @actionObject.y + 32
        end
        $scene_manager.currentMap.events.push(projectile)
        newProjectile = $scene_manager.currentMap.events[-1]
        newProjectile.move_self(@facing,strikeRange,strikeSpeed)
        newProjectile.activate_event()
        #create new projectile
        #send it moving that direction till it hits something
        #if it can hurt it activate it and damage the event.

    end

    def attack_melee(damage,animationName,range=32)
        evtCheck = @detection.check_surrounding(@facing,range)
        case @facing
        when "up"
            strike_melee(evtCheck,0,animationName,damage)
        when "down"
            strike_melee(evtCheck,1,animationName,damage)
        when "left"
            strike_melee(evtCheck,2,animationName,damage)
        when "right"
            strike_melee(evtCheck,4,animationName,damage)
        end
    end 

    def attack_ranged(projectile,weapon)
        evtCheck = @detection.check_surrounding(@facing,@detectRange)
        case @facing
        when "up"
            strike_ranged(projectile,weapon)
        when "down"
            strike_ranged(projectile,weapon)
        when "left"
            strike_ranged(projectile,weapon)
        when "right"
            strike_ranged(projectile,weapon)
        end
    end

    def update
    end
    def draw
    end
end