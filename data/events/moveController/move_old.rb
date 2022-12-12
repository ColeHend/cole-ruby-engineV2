def inVectorArray(objectToMove)
    vectorArr = MoveCollision.new.vectorArray
    vectorArr.each_with_index{|impass,index|
        if objectToMove.x == impass.x && objectToMove.y == impass.y
            return true
        end
    }
    return false
end
def checkVectorArr(vectorArr,objectToMove)
    vectorArr.each_with_index{|impass,index|
        if objectToMove.x == impass.x && objectToMove.y == impass.y
            return false
        end
    }
    return true
end


def calculatePath(objectToMove,objectToFollow)
    done = false
    vectorArr = MoveCollision.new.vectorArray
    path = []

    followX = (objectToFollow.x+(objectToFollow.w/2)) - (objectToMove.x+(objectToMove.w/2))
    followY = (objectToFollow.y+((objectToFollow.h/4)*3)) - (objectToMove.y+((objectToMove.h/4)*3))
    vectorFollow = Vector2.new(objectToFollow.x/32,objectToFollow.y/32)
    vectorToMove = Vector2.new(objectToMove.x/32,objectToMove.y/32)

    theThread = Thread.new{
        until done == true do
            
        end
    }
end
    def buildPath(objectToMove,objectToFollow)
        #----------------------------------------------------------
        followAbsX = ((objectToFollow.x+(objectToFollow.w/2)) - (objectToMove.x+(objectToMove.w/2)) ).abs #g(n) exact distance y
        followAbsY = ((objectToFollow.y+((objectToFollow.h/4)*3)) - (objectToMove.y+((objectToMove.h/4)*3)) ).abs#g(n) exact distance x
         
        vectorFollow = Vector2.new(objectToFollow.x/32,objectToFollow.y/32)
        vectorToMove = Vector2.new(objectToMove.x/32,objectToMove.y/32)
         
        maxAbs = [followAbsX,followAbsY].max
         
        path = Array.new
        newPath = []
        theThread = Thread.new{
        until path[0] != nil do
         
            newVectorToMove = vectorToMove
            if followAbsX == maxAbs
                if vectorFollow.x < newVectorToMove.x # left
                    if inVectorArray(newVectorToMove.x-1) == false
                        newVectorToMove.x -= 1
                        newPath.push("left")
                    elsif inVectorArray(newVectorToMove.x-1) == true
                        if vectorFollow.y < newVectorToMove.y # up
                            if inVectorArray(newVectorToMove.y-1) == false
                                newVectorToMove.y -= 1
                                newPath.push("up")
                            end
                        elsif vectorFollow.y > newVectorToMove.y # down
                            if inVectorArray(newVectorToMove.y+1) == false
                                newVectorToMove.y += 1
                                newPath.push("down")
                            end
                        end
                    end
                elsif vectorFollow.x > newVectorToMove.x # right
                    if inVectorArray(newVectorToMove.x+1) == false
                        newVectorToMove.x += 1
                        newPath.push("right")
                    elsif inVectorArray(newVectorToMove.x+1) == true
                        if vectorFollow.y < newVectorToMove.y # up
                            if inVectorArray(newVectorToMove.y-1) == false
                                newVectorToMove.y -= 1
                                newPath.push("up")
                            end
                        elsif vectorFollow.y > newVectorToMove.y # down
                            if inVectorArray(newVectorToMove.y+1) == false
                                newVectorToMove.y += 1
                                newPath.push("down")
                            end
                        end
                    end
                end
            elsif followAbsY == maxAbs
                if vectorFollow.y < newVectorToMove.y # up
                    if inVectorArray(newVectorToMove.y-1) == false
                        newVectorToMove.y -= 1
                        newPath.push("up")
                    elsif inVectorArray(newVectorToMove.y-1) == true
                        if vectorFollow.x < newVectorToMove.x # left
                            if inVectorArray(newVectorToMove.x-1) == false
                                newVectorToMove.x -= 1
                                newPath.push("left")
                            end
                        elsif vectorFollow.x > newVectorToMove.x # right
                            if inVectorArray(newVectorToMove.x+1) == false
                                newVectorToMove.x += 1
                                newPath.push("right")
                            end
                        end
                    end
                elsif vectorFollow.y > newVectorToMove.y # down
                    if inVectorArray(newVectorToMove.y+1) == false
                        newVectorToMove.y += 1
                        newPath.push("down")
                    elsif inVectorArray(newVectorToMove.y+1) == true
                        if vectorFollow.x < newVectorToMove.x # left
                            if inVectorArray(newVectorToMove.x-1) == false
                                newVectorToMove.x -= 1
                                newPath.push("left")
                            end
                        elsif vectorFollow.x > newVectorToMove.x # right
                            if inVectorArray(newVectorToMove.x+1) == false
                                newVectorToMove.x += 1
                                newPath.push("right")
                            end
                        end
                    end
                end
            else
            end
            if newVectorToMove.x == vectorFollow.x && newVectorToMove.y == vectorFollow.y
             puts("run")
                path.push(newPath[0])
                self.close
                return newPath[0]
                
            end
        end}
        #---------------------------------------------------------------- 
    end
    def follow(attackerClass,objectToMove,vectorToMove,objectToFollow,moveArray)
        if objectToFollow != nil
            speed = 0.25
            time = 10
            moveLeft = ->(){
                attackerClass.facing = "left"
                Move(vectorToMove,objectToMove,attackerClass.facing,speed,time)
            }
            moveRight = ->(){
                attackerClass.facing = "right"
                Move(vectorToMove,objectToMove,attackerClass.facing,speed,time)
            }
            moveUp = ->(){
                attackerClass.facing = "up"
                Move(vectorToMove,objectToMove,attackerClass.facing,speed,time)
            }
            moveDown = ->(){
                attackerClass.facing = "down"
                Move(vectorToMove,objectToMove,attackerClass.facing,speed,time)
            }
            toMoveDirection = buildPath(objectToMove,objectToFollow)
            puts("toMoveDirection: #{toMoveDirection}")
            case toMoveDirection
                when "up"
                    moveArray.push(moveUp)
                when "down"
                    moveArray.push(moveDown)
                when "left"
                    moveArray.push(moveLeft)
                when "right"
                    moveArray.push(moveRight)
            end
        end
    end
    def RandomMove(vectorToMove,objectToMove,moveDist,moveArray,facing,delayStart = Gosu::milliseconds())
        @randomNum = rand(4)
        speed = 0.25
        time = 10
        @delayStart = delayStart
        moveLeft = ->(){
            facing = "left"
            Move(vectorToMove,objectToMove,facing,speed,time)
        }
        moveRight = ->(){
            facing = "right"
            Move(vectorToMove,objectToMove,facing,speed,time)
        }
        moveUp = ->(){
            facing = "up"
            Move(vectorToMove,objectToMove,facing,speed,time)
        }
        moveDown = ->(){
            facing = "down"
            Move(vectorToMove,objectToMove,facing,speed,time)
        }
        moveWaitTime = (Gosu::milliseconds()/100 % 32)
        #puts("RandomMoveTime: #{moveWaitTime}")
        if (moveWaitTime == 0)
            moveNumber = moveDist
            case @randomNum
            when 0
                moveNumber.times{moveArray.push(moveRight) }
            when 1
                moveNumber.times{moveArray.push(moveUp) }
            when 2
                moveNumber.times{moveArray.push(moveLeft) }
            when 3
                moveNumber.times{ moveArray.push(moveDown)}
            end
            @delayStart = Gosu::milliseconds()
        end
    end