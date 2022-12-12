module Window_Tools
    require_relative "input_trigger.rb"
    def create_window(x,y,width,height) #use the same grid pattern as events use ("fancyWindowSkin",,0,0,0,0,6,4)
        @windowSkin = GameObject.new(0,0, 0, 0, $scene_manager.windowskin, nil, 6, 4)
        for a in (0..width) do
            for b in (0..height) do
                @windowSkin.set_animation(0)
                @windowSkin.x = ((x+a)*32)
                @windowSkin.y = ((y+b)*32)
                #@windowSkin.draw(nil, 1, 1, 0xff, 0xff, nil, nil, 6, false)
                @windowSkin.draw#(map = nil, scale_x = 1, scale_y = 1, alpha = 0xffffff, color = 0xffffff, angle = nil, flip = nil, z_index = 0, round = false)
                #@windowSkin.animate([0],8)
                if a == 0 && b == 0
                    @windowSkin.set_animation(4)
                    #@windowSkin.animate([4],8)
                    @windowSkin.x = (x*32)
                    @windowSkin.y = (y*32)
                    @windowSkin.draw(nil, 1, 1, 0xff, 0xffffff, nil, nil, 8, false)
                elsif a == width && b == 0
                    @windowSkin.set_animation(5)
                    #@windowSkin.animate([5],8)
                    @windowSkin.x = ((x+a)*32)
                    @windowSkin.y = ((y+b)*32)
                    @windowSkin.draw(nil, 1, 1, 0xff, 0xffffff, nil, nil, 8, false)
                elsif a == width && b == height
                    @windowSkin.set_animation(11)
                    #@windowSkin.animate([11],8)
                    @windowSkin.x = ((x+a)*32)
                    @windowSkin.y = ((y+b)*32)
                    @windowSkin.draw(nil, 1, 1, 0xff, 0xffffff, nil, nil, 8, false)
                elsif a == 0 && b == height
                    @windowSkin.set_animation(10)
                    #@windowSkin.animate([10],8)
                    @windowSkin.x = ((x+a)*32)
                    @windowSkin.y = ((y+b)*32)
                    @windowSkin.draw(nil, 1, 1, 0xff, 0xffffff, nil, nil, 8, false)
                end
            end
        end
    end
    class Option
        attr_reader :text, :function, :text_image
        def initialize(text, function)
            @text = text
            @function = function
            @text_image = Gosu::Image.from_text(text, 20)
        end
    end
    class OptionsBox
        attr_accessor :notCurrentColor, :currentColor, :hidden
        attr_reader :currentOp, :stackName
        include WindowBase
        @@boxNumber = 0
        def initialize(x=400,y=225,width=70,height=70,choice,done)
            #@stackName = stackName
            @input = $scene_manager.input #
            @@boxNumber += 1
            @stackName = "optionsBox #{@@boxNumber}"
            @input.addToStack(@stackName)
            @hidden = false
            @optionsBoxHeightMod = 0
            @x, @y, @width, @height = x, y, width, height
            @choices = choice
            @choiceNames = @choices.map{|e|e.text_image}
            @choice =  @choices.map{|e|e.function}
            @choiceAmount = @choiceNames.length 
            @onScreenChoiceAmount = @height / 27
            @done = done
            @drawChoice,@currentOp = true,0
            
            @white = Gosu::Color.argb(0xff_ffffff)
            @black = Gosu::Color.argb(0xff_000000)
            @orange = Gosu::Color.argb(0xff_fc5203)
            @brightGreen = Gosu::Color.argb(0xff_2ca81e)
            @notCurrentColor = @white
            @currentColor = @brightGreen
            @colors = Array.new(40,@notCurrentColor)
            @colors[0] = @currentColor
            @buttondown = 0
            @player = $scene_manager.scene["player"]
            #$can_move = !@drawDialog
        end
    
        def change_options(newChoices)
            @notCurrentColor = @white
            @currentColor = @brightGreen
            @colors = Array.new(40,@notCurrentColor)
            @colors[0] = @currentColor
            @choices = newChoices
            @choice =  @choices.map{|e|e.function}
            @choiceNames = @choices.map{|e|e.text_image}
            @choiceAmount = @choiceNames.length 
        end
        
        def doInput(key)
            if $scene_manager.input.inputStack[-1] == @stackName
                case key
                when "up"
                    if @currentOp != 0
                        @colors[@currentOp] = @notCurrentColor
                        @currentOp -= 1
                        @colors[@currentOp] = @currentColor
                    elsif @currentOp == 0
                        @colors[@currentOp] = @notCurrentColor
                        @currentOp = @choiceAmount - 1
                        @colors[@currentOp] = @currentColor
                    end
                when "down"
                    if @choiceAmount != (@currentOp+1)
                        @colors[@currentOp] = @notCurrentColor
                        @currentOp += 1
                        @colors[@currentOp] = @currentColor
                    elsif @choiceAmount == (@currentOp+1)
                        @colors[@currentOp] = @notCurrentColor
                        @currentOp = 0
                        @colors[@currentOp] = @currentColor
                    end
                when "select"
                        @choice[@currentOp].call()
                        @currentOp = 0
                        @colors = Array.new(25,@notCurrentColor)
                        @colors[@currentOp] = @currentColor
                        
                        @done = true
                end          
            end
        end
    
        def update
            @choiceNames = @choices.map{|e|e.text_image}
            @choice =  @choices.map{|e|e.function}
            @choiceAmount = @choiceNames.length
            if @input.keyPressed(InputTrigger::UP) then #down
                doInput("up") 
            elsif @input.keyPressed(InputTrigger::DOWN) then #up
                doInput("down")
            elsif @input.keyPressed(InputTrigger::SELECT) then #select
                doInput("select")
            end
            
        end
            
        def hidden(visible)
            @hidden = visible
        end  
          
        def draw
            if !@hidden
                create_window(@x,@y,@width,(@height))
    
                @choiceY = (@y*32) + 15
                for a in (0...@choiceAmount)
                    @choiceNames[a].draw((@x*32)+10, @choiceY+(20*a), 8,scale_x = 1, scale_y = 1, color = @colors[a])
                end
            end
        end
          
    end
    
end