class Move_Controller
    include Animate
    def initialize(object,facing,sprite)
        @object = object
        @facing = facing
        @sprite = sprite
        @speed = 0.75
        @animationTime = 7
        @state = "stop"
        @input = $scene_manager.input
    end
    def setMoveState()
        case @state
        when "moving"
            # puts("player state: #{@state}")
            @sprite.draw()
            draw_character(@sprite, @facing ,@animationTime)
        when "stop"
            @sprite.draw()
            draw_character(@sprite,"#{@facing}Stop",1)
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
        
        collisionDetect = MoveCollision.new(@object)
        checkBoostArr = [20,0,0,6]
        if vector.y > 0
            if collisionDetect.check_surrounding("down",checkBoostArr[0]) == false
                @object.y = @object.y + (vector.y * 4)
            end
        elsif vector.y < 0
            if collisionDetect.check_surrounding("up",checkBoostArr[1]) == false
                @object.y = @object.y + (vector.y * 4)
            end
        elsif vector.x > 0
            if collisionDetect.check_surrounding("right",checkBoostArr[2]) == false
                @object.x = @object.x + (vector.x * 4)
            end
        elsif vector.x < 0
            if collisionDetect.check_surrounding("left",checkBoostArr[3]) == false
                @object.x = @object.x + (vector.x * 4)
            end
        end
    end
    def update
        move_input()
    end
    def draw
        setMoveState()
    end
end