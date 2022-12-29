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
        @impassArr = $scene_manager.scenes["map"].currentMap.blockedTiles
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
    def check_range(rangeBoost=0,removeBlock=false)
        range = 32 + rangeBoost
        allInRange = []
        nearby = closestBlocked()
        nearby.each_with_index{|item,index|
            # if !item.is_a?(Block)
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
            # end
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
                theRange = checkRange.select{|item| 
                    case dir
                    when "up"
                        return item.y < @objectToMove.y
                    when "down"
                        return item.y > @objectToMove.y
                    when "left"
                        return item.x < @objectToMove.x
                    when "right"
                        return item.x > @objectToMove.x
                    end
                }
                theRange.each{|item|
                    case dir
                    when "up"
                        if item.x == @objectToMove.x && item.y < @objectToMove.y
                            toReturn.push(item)
                        end
                    when "down"
                        if item.x == @objectToMove.x && item.y > @objectToMove.y
                            toReturn.push(item)
                        end
                    when "right"
                        newer = item.x > @objectToMove.x 
                        puts((@objectToMove.x - item.x).abs)
                        if (@objectToMove.x - item.x).abs >= 1 && item.y == @objectToMove.y
                            toReturn.push(item)
                        end
                    when "left"
                        if item.x < @objectToMove.x && item.y == @objectToMove.y
                            toReturn.push(item)
                        end
                    end
                }
            end
            return [toReturn,checkRange]
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