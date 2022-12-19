class Battle_System
    def initialize(actionObject,range,facing)
        @detection = MoveCollision.new(actionObject)
        @facing = facing
        @detectRange = range
        @evtRangeQueen = @detection.check_range(@detectRange,true)
        @evtRangeRook = @detection.check_surrounding("all",@detectRange)
        
    end
    def attack_melee(damage,animationName)
        evtCheck = @detection.check_surrounding(@facing,32)
        case @facing
        when "up"
            if evtCheck.length > 0
                if evtCheck.length == 1
                    evtCheck.stats.currentHP -= damage
                    $scene_manager.currentMap.
                else
                    
                end
            end
        when "down"
            if evtCheck.length > 0
                if evtCheck.length == 1
                
                else
                    
                end
            end
        when "left"
            if evtCheck.length > 0
                if evtCheck.length == 1
                
                else
                    
                end
            end
        when "right"
            if evtCheck.length > 0
                if evtCheck.length == 1
                
                else
                    
                end
            end
        end
    end
    def attack_ranged()
        evtCheck = @detection.check_surrounding(@facing,@detectRange)
        case @facing
        when "up"
            
        when "down"
            
        when "left"

        when "right"
            
        end
    end

    def update
    end
    def draw
    end
end