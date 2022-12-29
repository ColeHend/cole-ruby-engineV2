#require_relative "../../../files/animate.rb"
class Event_Core
    include Animate
    attr_accessor :eventName,:vector,:passible, :x, :y, :mapNumber, :activateType, :activateEvent, :currPage, :imgName,:facing, :h, :w, :columns, :rows, :bestiaryName
    def initialize(mapNumber,eventName,x,y,activateType,currPage,activateEvent,imgName=nil,columns=4,rows=4,bbHeight=nil,bbWidth=nil,battleCoreName="god")
        @eventName = eventName # Important
        @x,@y = x, y # Important
        @mapNumber = mapNumber  # Important
        @activateType = activateType # Important
        @activateEvent = activateEvent
        @currPage = currPage
        @imgName = imgName
        @passible = false
        @facing = "down"
        @vector = Vector2.new(0, 0)
        @w,@h = bbWidth, bbHeight
        @columns,@rows = columns, rows
        @bestiaryName = battleCoreName
    end
    def activate_event
        @activateEvent[@currPage].call
    end
    def update
    end
    def draw
    end
end