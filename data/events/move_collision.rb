class MoveCollision
    def initialize(objectToMove)
        @objectToMove = objectToMove
        
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
    def closestBlocked()
        @impassArr = $scene_manager.currentMap.blockedTiles
        arrByClose = []
        arrToReturn = []
        @impassArr.each{|evt|
            xDist = ((@objectToMove.x/32) - (evt.y/32)).abs()
            yDist = ((@objectToMove.y/32) - (evt.y/32)).abs()
            xyDist = xDist + yDist
            arrByClose.push([evt,xyDist])
        }
        arrByClose.sort_by{|item|item[1]}
        arrByClose.each{|item|arrToReturn.push(item[0])}
        return arrToReturn
    end
    def check_range(rangeBoost=0)
        range = 32 + rangeBoost
        allInRange = []
        nearby = closestBlocked()
        nearby.each_with_index{|item,index|
            if (range + 6) >= (@objectToMove.y + (@objectToMove.h) - (item.y + item.h)).abs && ((@objectToMove.x) - item.x).abs <= (range - 16)
                if overlap?(((item.x)...(item.x+item.w)),((@objectToMove.x)...(@objectToMove.x+@objectToMove.w))) == true && overlap?(((item.y)...(item.y+item.h)),((@objectToMove.y)...(@objectToMove.y+@objectToMove.h))) == true
                    allInRange.push(item)
                end 
            end
            if (range) >= ((eventY) - targetY).abs && ((eventX+eventW) - targetX).abs <= (range)
                if  overlap?(((item.y)...(item.y+item.h)),((@objectToMove.y+16)...(@objectToMove.y+@objectToMove.h))) == true && overlap?(((item.x)...(item.x+item.w)),((@objectToMove.x)...(@objectToMove.x+@objectToMove.w))) == true
                    allInRange.push(item)
                end
            end
        }
        return [true,allInRange]
            # case dir
            # when "up"
            # when "down"
            #     if (range ) >= ((eventY) - targetY).abs && ((eventX+eventW) - targetX).abs <= (range - 16)
            #         if overlap?(((item.x)...(item.x+item.w)),((@objectToMove.x)...(@objectToMove.x+@objectToMove.w))) == true && overlap?(((item.y)...(item.y+item.h)),((@objectToMove.y)...(@objectToMove.y+@objectToMove.h))) == true
            #             return [true,item]
            #         end
            #     end
            # when "right"
            # when "left"
            #     if (range) >= ((eventY) - targetY).abs && ((eventX+eventW) - targetX).abs <= (range)
            #         if  overlap?(((item.y)...(item.y+item.h)),((@objectToMove.y+16)...(@objectToMove.y+@objectToMove.h))) == true && overlap?(((item.x)...(item.x+item.w)),((@objectToMove.x)...(@objectToMove.x+@objectToMove.w))) == true
            #             return [true,item]
            #         end
            #     end
            # end
    end
    def check_nearby(rangeBoost=0)
        checkRange = checkR[1] = check_range(rangeBoost)
        if checkRange.length > 0
            
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