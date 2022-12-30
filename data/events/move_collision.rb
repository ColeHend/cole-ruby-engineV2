class MoveCollision
    def initialize(objectToMove,player=false)
        @objectToMove = objectToMove
        @isPlayer = player
    end
    def overlap?(r1,r2)
        !(r1.first > r2.last || r1.last < r2.first)
    end
    def sameOb(obj1,obj2)
        if obj1.is_a?(Event_NPC) or obj1.is_a?(Event_Player) or obj1.is_a?(GameObject) 
            if  obj1.w != obj2.w && obj1.h != obj2.h 
                return false
            end
        end
        return true
    end
    def collideCheck(targetEvent,event,dir,rangeBoost,evtReturn=true)
        range = 32
        range += rangeBoost
        # if event.is_a?(Event) == true || event.is_a?(GameObject) == true && targetEvent.is_a?(Event) == true || targetEvent.is_a?(GameObject) == true
            targetX = targetEvent.x
            targetY = targetEvent.y
            if defined?(targetEvent.w) != nil
                targetW = targetEvent.w
            else
                targetW = 31
            end
            if defined?(targetEvent.h) != nil
                targetH = targetEvent.h
            else
                targetH = 46
            end
            eventX = event.x
            eventY = event.y
            eventW = event.w
            eventH = event.h
            case dir
                when "up"
                    if (range + 6) >= (eventY + (eventH) - (targetY + targetH)).abs && ((eventX) - targetX).abs <= (range - 16) #up
                        if (overlap?(((eventY)...(eventY+eventH)),(targetY...(targetY+targetH-8))) === true) && (overlap?(((eventX)...(eventX+eventW)),((targetX)...(targetX+targetW))) === true)
                            if evtReturn == true
                                return event
                            end
                            return true
                        end
                    end
                when "down"
                    if range >= (eventY+(16) - (targetY + targetH)).abs && ((eventX) - targetX).abs <= (range-16) #down
                        if (overlap?(((eventY)...(eventY+eventH)),(targetY...(targetY+targetH))) === true) && (overlap?(((eventX)...(eventX+eventW)),((targetX)...(targetX+targetW))) === true)
                            if evtReturn == true
                                return event
                            end
                            return true
                        end
                    end
                when "left"
                    if (range ) >= ((eventY) - targetY).abs && ((eventX+eventW) - targetX).abs <= (range) #up
                        if (overlap?(((eventX)...(eventX+eventW)),((targetX)...(targetX+targetW))) === true) && (overlap?(((eventY)...(eventY+eventH)),((targetY+16)...(targetY+targetH))) === true)
                            if evtReturn == true
                                return event
                            end
                            return true
                        end
                    end
                when "right"
                    if (range ) >= ((eventY) - targetY).abs && (eventX - (targetX + targetW)).abs <= (range) #up
                        if (overlap?(((eventX)...(eventX+eventW)),((targetX)...(targetX+targetW))) === true) && (overlap?(((eventY)...(eventY+eventH)),((targetY+16)...(targetY+targetH))) === true)
                            if evtReturn == true
                                return event
                            end
                            return true
                        end
                    end
            end
        # else
            return false
        # end
    end

    def check_range(rangeBoost=0,removeBlock=false)
        range = 32 + rangeBoost
        allInRange = []
        # nearby = closestBlocked()
        nearby = $scene_manager.currentMap.blockedTiles
        if @isPlayer == false
            hasPlayer = false
            nearby.each{|e|
                if e.is_a?(Event_Player)
                    hasPlayer = true
                end
            }
            if hasPlayer == false
                nearby.push($scene_manager.scenes["player"])
            end
        end
        nearby = nearby.uniq()
        nearby.each_with_index{|item,index|
             if item.is_a?(Event_Player) == false || item.is_a?(Event_Player) == true && @isPlayer == false 
                objWtoM = 46 or item.w
                objHtoM = 31 or item.h
                if (range + 6) >= (@objectToMove.y + (objHtoM) - (item.y + item.h)).abs && ((@objectToMove.x) - item.x).abs <= (range - 16)
                    if overlap?(((item.x)...(item.x+item.w)),((@objectToMove.x)...(@objectToMove.x+objWtoM))) == true && overlap?(((item.y)...(item.y+item.h)),((@objectToMove.y)...(@objectToMove.y+objHtoM))) == true
                        allInRange.push(item)
                    end 
                end
                if (range) >= ((@objectToMove.y) - item.y).abs && ((@objectToMove.x+objWtoM) - item.x).abs <= (range)
                    if  overlap?(((item.y)...(item.y+item.h)),((@objectToMove.y+16)...(@objectToMove.y+objHtoM))) == true && overlap?(((item.x)...(item.x+item.w)),((@objectToMove.x)...(@objectToMove.x+objWtoM))) == true
                        allInRange.push(item)
                    end
                end
             end
        }
        if removeBlock == true
            toRemove = []
            allInRange.each_with_index{|evt,index|
                if evt.is_a?(Block)
                    toRemove.push(index)
                elsif evt.is_a?(Spell)
                    toRemove.push(index)
                end
            }
            toRemove.each{|i|allInRange.delete_at(i)}
            return [true,allInRange]
        else
            return [true,allInRange]
        end
    end

    def check_surrounding(dir,rangeBoost=0)
        
        checkR = check_range(rangeBoost)
        checkRange = checkR[1]
        toReturn = []
        if checkRange.length > 0
            if dir == "all"
                checkRange.each{|item|
                    if item.x == @objectToMove.x && item.y < @objectToMove.y
                        toReturn.push(["up",item])
                    end
                    if item.x == @objectToMove.x && item.y < @objectToMove.y
                        toReturn.push(["down",item])
                    end
                    if item.x > @objectToMove.x && item.y == @objectToMove.y
                        toReturn.push(["right",item])
                    end
                    if item.x < @objectToMove.x && item.y == @objectToMove.y
                        toReturn.push(["left",item])
                    end
                }
            else
                checkRange.each{|item|
                    case dir
                    when "up"
                        if collideCheck(@objectToMove,item,dir,0,false) == true
                            toReturn.push(item)
                        end
                    when "down"
                        if collideCheck(@objectToMove,item,dir,0,false) == true
                            toReturn.push(item)
                        end
                    when "right"
                        if collideCheck(@objectToMove,item,dir,0,false) == true
                            toReturn.push(item)
                        end
                    when "left"
                        if collideCheck(@objectToMove,item,dir,0,false) == true
                            toReturn.push(item)
                        end
                    end
                }
            end
            if toReturn.length > 0
                
                return [toReturn,checkRange]
            else
                return false
            end
        else
            return false
        end
    end
    def update
        @impassArr = $scene_manager.currentMap.blockedTiles
    end
    def draw
    end
end