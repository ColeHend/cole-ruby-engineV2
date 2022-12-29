module Path_Calc
    def checkMoveMap(vectorToMove,moveMap)
        return [
            moveMap[vectorToMove.y-1][vectorToMove.x],
            moveMap[vectorToMove.y+1][vectorToMove.x],
            moveMap[vectorToMove.y][vectorToMove.x-1],
            moveMap[vectorToMove.y][vectorToMove.x+1]
        ]
    end
    def calc_path(objectToMove,objectToFollow)
        vectorFollow = Vector2.new(objectToFollow.x/32,objectToFollow.y/32)
        vectorToMove = Vector2.new(objectToMove.x/32,objectToMove.y/32)
        
        currMap = $scene_manager.currentMap.mapfile['draw']
        vectorArr = MoveCollision.new.vectorArray
        blockedSpots = []
        plannedPath = []
        moveMapArr = Array.new(currMap.length,Array.new(currMap[0].length,true))
        vectorArr.each{|impass| 
            blockedSpots.push[impass.y,impass.x]
            moveMapArr[impass[0]][impass[1]] = false
        }
        until vectorToMove.x == vectorFollow.x && vectorToMove.y == vectorFollow.y
            vectorX = vectorToMove.x - vectorFollow.x
            vectorY = vectorToMove.y - vectorFollow.y
            canMove = checkMoveMap(vectorToMove,currMap)
            plan = []
            if (vectorX).abs > (vectorY).abs #more horizontal
                if vectorX < 0  # more to right
                    if canMove[3] == true
                        vectorToMove.x = vectorToMove.x + 1
                        plan.push('right')
                    else
                        
                    end
                else            # more to left
                    if canMove[2] == true
                        vectorToMove.x = vectorToMove.x - 1
                        plan.push('left')
                    else
                        
                    end
                end
            else                 #----------- More Vertical
                if vectorY < 0 #more below
                    if canMove[1] == true
                        vectorToMove.y = vectorToMove.y + 1
                        plan.push('down')
                    else
                        
                    end
                else            #more above
                    if canMove[0] == true
                        vectorToMove.y = vectorToMove.y - 1
                        plan.push('up')
                    else
                        
                    end
                end
            end
        end
    end
end