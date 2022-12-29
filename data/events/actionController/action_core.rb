class Action_Core
    def initialize(actionObject,stats,moveType,targetObject,range=2*32,state="neutral")
        @actionObject = actionObject
        @stats = stats
        @moveType = moveType # "none" or "random" or "follow"
        @targetObject = targetObject # need a target to "follow"
        @detection = MoveCollision.new(@actionObject)
        
        @range = range
        
        @state = state
    end

    def actionNatureState()
        case @state
        when "evil"
            
        when "neutral"
            
        when "peaceful"

        when "ally"

        else
            
        end
    end
    def nature_evil()
        if @evtsInRange.length > 0
            
        end
    end
    def nature_neutral()
        if @evtsInRange.length > 0
            
        end
    end
    def nature_peaceful()
        if @evtsInRange.length > 0
            
        end
    end
    def nature_ally()
        if @evtsInRange.length > 0
        else 
        end
    end
    def update
        @evtsInRange = @detection.check_range(@range,true)
    end

    def draw
    end
end