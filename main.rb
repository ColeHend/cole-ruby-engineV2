require 'minigl'
include MiniGL
Dir[File.join(__dir__,'data', '*.rb')].each { |file| require file }
Dir[File.join(__dir__, 'data','events', '*.rb')].each { |file| require file }
Dir[File.join(__dir__,'data','events', 'battle', '*.rb')].each { |file| require file }
Dir[File.join(__dir__,'data','events', 'moveController', '*.rb')].each { |file| require file }
Dir[File.join(__dir__,'data', 'maps', '*.rb')].each { |file| require file }
Dir[File.join(__dir__,'data', 'input', '*.rb')].each { |file| require file }


class MyGame < GameWindow
    def initialize
        super 800, 600, false 
        $window = self
        $scene_manager = Scene_Manager.new
        $scene_manager.startUp()
        $scene_manager.setScene("titlescreen")
    end
    def update
        $time = Gosu::milliseconds()
        self.caption = "Game FPS = " +(Gosu.fps()).to_s
        KB.update
        $scene_manager.update
    end
    def draw
        $scene_manager.draw
    end
end
game = MyGame.new
game.show
gets