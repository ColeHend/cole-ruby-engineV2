class Move_Controller
    def initialize(object,facing)
        @object = object
        @facing = facing
        @speed = 0.75
        @animationTime = 7
    end
    def setMoveState(state)
        case state
        when "moving"
            draw_character(@object, @facing ,@animationTime)
        when "stop"
            draw_character(@object,"#{@facing}Stop",1)
        end
    end
    def move_input
        if Gosu.button_down?(InputTrigger::RUN)
            @speed = 1.25
            @animationTime = 5
        elsif Gosu.button_down?(InputTrigger::SNEAK)
            @speed = 0.25
            @animationTime = 10
        else
            @speed = 0.75
            @animationTime = 7
        end

        if @input.keyDown(InputTrigger::UP)
            @facing = "up"
            @state = "moving"
            Move()
        elsif @input.keyDown(InputTrigger::DOWN)
            @facing = "down"
            @state = "moving"
            Move()
        elsif @input.keyDown(InputTrigger::LEFT)
            @facing = "left"
            @state = "moving"
            Move()
        elsif @input.keyDown(InputTrigger::RIGHT)
            @facing = "right"
            @state = "moving"
            Move()
        elsif @input.keyDown(InputTrigger::ESCAPE)
            @input.addToStack("menu")
            $scene_manager.switch_scene("menu")
        elsif @input.keyReleased(InputTrigger::UP)
            @state = "stop"
        elsif @input.keyReleased(InputTrigger::DOWN)
            @state = "stop"
        elsif @input.keyReleased(InputTrigger::LEFT)
            @state = "stop"
        elsif @input.keyReleased(InputTrigger::RIGHT)
            @state = "stop"
        end
    end
    def Move()
        vector = Vector2.new(0, 0)
        vector.x = 0
        vector.y = 0
        collisionDetect = MoveCollision.new(@object)
        
        case @facing
            when "down"
                vector.y = @speed
            when "up"
                vector.y = -@speed
            when "right"
                vector.x = @speed
            when "left"
                vector.x = -@speed
            when "none"
                vector.x = 0
                vector.y = 0
        end

        if vector.y > 0
            if collisionDetect.check_surrounding("down",@object) == false
                @object.y = @object.y + (vector.y * 4)
            end
        elsif vector.y < 0
            if collisionDetect.check_surrounding("up",@object) == false
                @object.y = @object.y + (vector.y * 4)
            end
        elsif vector.x > 0
            if collisionDetect.check_surrounding("right",@object) == false
                @object.x = @object.x + (vector.x * 4)
            end
        elsif vector.x < 0
            if collisionDetect.check_surrounding("left",@object) == false
                @object.x = @object.x + (vector.x * 4)
            end
        end
    end
    def update
        move_input()
    end
    def draw
        setMoveState(@state)
    end
end