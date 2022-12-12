module Animate  # @sprite[@dir].draw(@x*32,@y*32,@z)
    attr_accessor :direction, :x, :y, :z, :animate,:canMove, :moving
        
        @multiplier = 1

    def update_stuff(x,y,dir,animate,canMove,moving)
        @dir, @x, @y, @animate, @canMove,@moving = dir, x, y, animate, canMove, moving
    end

    def draw_character(object, direction,time)
        @object = object
        @direction = direction
        @time = time
        case @direction
        when "down"
            @object.animate([0,1,2,3],@time)
        when "left"
            @object.animate([4,5,6,7],@time)
        when "right"
            @object.animate([8,9,10,11],@time)
        when "up"
            @object.animate([12,13,14,15],@time)
        when "downStop"
            @object.set_animation(0)
        when "leftStop"
            @object.set_animation(4)
        when "rightStop"
            @object.set_animation(8)
        when "upStop"
            @object.set_animation(12)
        end
    end
   
end