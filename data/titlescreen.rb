class TitleScreen
    include Window_Tools
    def initialize()
        @gameName = Gosu::Image.from_text("The Game", 30)
        @instructions = Gosu::Image.from_text("Press space to continue", 20)
        @input = $scene_manager.input
        @white = Gosu::Color.argb(0xff_ffffff)
        @black = Gosu::Color.argb(0xff_000000)
        @choice = [Option.new("New Game",->(){
            $scene_manager = SceneManager.new()
            $scene_manager.startUp()
            
            $scene_manager.input.addToStack("map")
            $scene_manager.setScene("map")
        }),
            Option.new("Load",->(){SaveGame.new().loadSave(1)}),
            Option.new("Exit",->(){$window.close()})]
        @optionsBox = OptionsBox.new(8,8,3,2,@choice,"")
        #@optionsBox.currentColor = Gosu::Color.argb(0xff_2ca81e)
    end

    def update()
        @optionsBox.update
        
    end

    def draw()
        @gameName.draw(240, 40, 5,scale_x = 1, scale_y = 1, color = @white)
        @instructions.draw(220, 70, 5,scale_x = 1, scale_y = 1, color = @white)
        @optionsBox.draw
    end

end