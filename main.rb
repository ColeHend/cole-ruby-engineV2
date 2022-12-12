require 'minigl'
include MiniGL
Dir[File.join(__dir__, 'data','events', '*.rb')].each { |file| require file }
Dir[File.join(__dir__,'data','events', 'battle', '*.rb')].each { |file| require file }
Dir[File.join(__dir__,'data','events', 'moveController', '*.rb')].each { |file| require file }
#Dir[File.join(__dir__,'data', 'maps','characters', '*.rb')].each { |file| require file }
#Dir[File.join(__dir__,'data', 'maps','characters','magic', '*.rb')].each { |file| require file }

class MyGame < GameWindow
    def initialize
        $scene_manager = Scene_Manager.new
        $scene_manager.startUp()
    end
    def update
        $scene_manager.update
    end
    def draw
        $scene_manager.draw
    end
end