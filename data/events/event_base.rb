require_relative "../characters/enemy_bestiary.rb"
require_relative "../characters/weapon_storage.rb"
require_relative "../characters/armor.rb"
class Event_Base 
    attr_accessor :eventName, :imgName,:x,:y,:w,:h,:bbWidth,:bbHeight,:columns,:rows,:mapNumber,:bestiaryName,:activateType
    def initialize(eventName, imgName,eventX,eventY,bbWidth,bbHeight,columns,rows,mapNumber,bestiaryName,activateType)
        @eventName = eventName # Important
        @x,@y = eventX, eventY # Important
        @mapNumber = mapNumber  # Important
        @activateType = activateType # Important
        @imgName = imgName
        @bbWidth,@bbHeight = bbWidth, bbHeight
        @w, @h = 32, 48
        @columns,@rows = columns, rows
        @bestiaryName = bestiaryName
    end
end
