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
def checkCanMoveLine(vectorArr,objectToMove,dist,dir)
    impassLineArr = []
    case dir
    when "up"
        vectorArr.each{|impass|
           if impass.x == objectToMove.x && impass.y < objectToMove.y && impass.y >= (objectToMove.y-dist)
                impassLineArr.push(impass)
           end
        }
    when "down"
        vectorArr.each{|impass|
            if impass.x == objectToMove.x && impass.y > objectToMove.y && impass.y <= (objectToMove.y+dist)
                impassLineArr.push(impass)
            end
         }
    when "left"
        vectorArr.each{|impass|
            if impass.y == objectToMove.y && impass.x < objectToMove.x && impass.x >= (objectToMove.x-dist)
                impassLineArr.push(impass)
            end
         }
    when "right"
        vectorArr.each{|impass|
            if impass.y == objectToMove.y && impass.x > objectToMove.x && impass.x <= (objectToMove.x-dist)
                impassLineArr.push(impass)
            end
         }
    end
    if impassLineArr.length > 0
        return [false,impassLineArr]
    else
        return true
    end
end
def pathNext(objectToMove,objectToFollow,vectorArr)
    vectorFollow = Vector2.new(objectToFollow.x/32,objectToFollow.y/32)
    vectorToMove = Vector2.new(objectToMove.x/32,objectToMove.y/32)
    vectorX = vectorToMove.x - vectorFollow.x
    vectorY = vectorToMove.y - vectorFollow.y
    checkUp = checkCanMoveLine(vectorArr,objectToMove,(vectorY).abs,"up")
    checkDown = checkCanMoveLine(vectorArr,objectToMove,(vectorY).abs,"up")
    checkLeft = checkCanMoveLine(vectorArr,objectToMove,(vectorY).abs,"up")
    check = checkCanMoveLine(vectorArr,objectToMove,(vectorY).abs,"up")
    if checkUp != true
        checkUp[1].sort_by { |event| event.y }
        upDist = vectorToMove.y - checkRight[1].y 
       if upDist >= (vectorX).abs 
        
       elsif upDist >= ((vectorY).abs*0.5)

       else

       end
    end
    checkDown = checkCanMoveLine(vectorArr,objectToMove,(vectorY).abs,"down")
    if checkDown != true
        downDist = (vectorToMove.y - checkRight[1].y).abs 
    end
    checkRight = checkCanMoveLine(vectorArr,objectToMove,(vectorX).abs,"right")
    if checkRight != true
        rightDist = (vectorToMove.x - checkRight[1].x).abs 
    end
    checkLeft = checkCanMoveLine(vectorArr,objectToMove,(vectorX).abs,"left")
    if checkLeft != true
        leftDist = vectorToMove.x - checkRight[1].x 
    end
    if (vectorX).abs > (vectorY).abs #more horizontal
        if vectorX < 0  # more to right
            if checkRight == true
                return ["right",(vectorX).abs]
            else
               if rightDist >= (vectorY).abs || rightDist > 
                    return ["right",rightDist]
               else
                
               end
            end
        else            # more to left
            if checkLeft == true
                return ["left",(vectorX).abs]
            else
                if leftDist >= (vectorY).abs
                    return ["left",leftDist]
                else
                    
                end
            end
        end
    else                 #----------- More Vertical
        if vectorY < 0 #more below
            if checkDown == true
                return ["down",(vectorY).abs]
            else
                
            end
        else            #more above
            if checkUp == true
                return ["up",(vectorY).abs]
            else
                
            end
        end
    end
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
     #returns either true or false and array of impass locations
     def checkCanMoveLine(dist,dir)
        impassLineArr = []
        case dir
        when "up"
            vectorArr.each{|impass|
               if impass.x == @objectToMove.x && impass.y < @objectToMove.y && impass.y >= (@objectToMove.y-dist)
                    impassLineArr.push(impass)
               end
            }
        when "down"
            vectorArr.each{|impass|
                if impass.x == @objectToMove.x && impass.y > @objectToMove.y && impass.y <= (@objectToMove.y+dist)
                    impassLineArr.push(impass)
                end
             }
        when "left"
            vectorArr.each{|impass|
                if impass.y == @objectToMove.y && impass.x < @objectToMove.x && impass.x >= (@objectToMove.x-dist)
                    impassLineArr.push(impass)
                end
             }
        when "right"
            vectorArr.each{|impass|
                if impass.y == @objectToMove.y && impass.x > @objectToMove.x && impass.x <= (@objectToMove.x-dist)
                    impassLineArr.push(impass)
                end
             }
        end
        if impassLineArr.length > 0
            return [false,impassLineArr.sort_by { |event| event.y }]
        else
            return true
        end
    end
    #returns a directions array to next square and vector of the final square
    def pathNext(objectToFollow)
        @vectorFollow = Vector2.new(@objectToFollow.x/32,@objectToFollow.y/32)
        @vectorX = @vectorToMove.x - @vectorFollow.x
        @vectorY = @vectorToMove.y - @vectorFollow.y
        closestOpen = vector2.new(0,0)
        nearbyRow = ->(dir){# return nearby row
            case dir
            when "up"
                rowUp = @passMap[@vectorToMove.y-1]
                return rowUp
            when "down"
                rowDown = @passMap[@vectorToMove.y+1]
                return rowDown
            when "right"
                rowRight = []
                for xRow in @passMap do
                rowRight.push(xRow[@vectorToMove.x+1])
                end
                return rowRight
            when "left"
                rowLeft = []
                for xRow in @passMap do
                    rowLeft.push(xRow[@vectorToMove.x-1])
                end
                return rowLeft
            end
        }
        move = ->(dir){
            case dir
            when "up"
                upDist = "up"
                checkUp = checkCanMoveLine((@vectorY).abs,"up")
                if checkUp != true
                    return upRow
                end
                return "up"
            when "down"
                downDist = "down"
                checkDown = checkCanMoveLine((@vectorY).abs,"down")
                if checkDown != true
                    return downRow
                end
                return "down"
            when "right"
                rightDist = "right"
                checkRight = checkCanMoveLine((@vectorX).abs,"right")
                if checkRight != true
                    return rightRow
                end
                return "right"
            when "left"
                leftDist = "left"
                checkLeft = checkCanMoveLine((@vectorX).abs,"left")
                if checkLeft != true
                    return leftRow
                end
                return "left"
            end
        }

        #impasses or direction
        upRow = nearbyRow.call("up")
        downRow = nearbyRow.call("down")
        rightRow = nearbyRow.call("right")
        leftRow = nearbyRow.call("left")
        canmoverow = []
        toMoveDir = []
        toGoToVector
        if (@vectorX).abs > (@vectorY).abs #more horizontal
            if @vectorX < 0  # more to right
                moveRight = move.call("right")
                if moveRight == "right"
                    toMoveDir.push("right")
                else
                    rightRow.each_with_index{|tile,index|
                        if tile == true
                            canmoverow.push([index,(index - @vectorToMove.y).abs()])
                        end
                    }
                    canmoverow.sort_by{|tile|tile[1]}
                    toGoToVector = vector2.new(@vectorToMove.x+1,canmoverow[0][0])
                    moveToDist = @vectorToMove.y - toGoToVector.y
                    
                    if moveToDist > 0
                        checkCanMoveUp = checkCanMoveLine(vectorArr,toGoToVector,(moveToDist).abs(),"up")
                        for i in (moveToDist).abs() do
                            toMoveDir.push("up")
                        end
                        toMoveDir.push("right")
                    else
                        checkCanMoveDown = checkCanMoveLine(vectorArr,toGoToVector,(moveToDist).abs(),"down")
                        for i in (moveToDist).abs() do
                            toMoveDir.push("down")
                        end
                        toMoveDir.push("right")
                    end
                end
            else            # more to left
                moveLeft = move.call("left")
                if moveLeft == "left"
                    toMoveDir.push("left")
                else
                    leftRow.each_with_index{|tile,index|
                        if tile == true
                            canmoverow.push([index,(index - @vectorToMove.y).abs()])
                        end
                    }
                    canmoverow.sort_by{|tile|tile[1]}
                    toGoToVector = vector2.new(@vectorToMove.x-1,canmoverow[0][0])
                    moveToDist = @vectorToMove.y - toGoToVector.y
                    
                    if moveToDist > 0
                        checkCanMoveUp = checkCanMoveLine(vectorArr,toGoToVector,(moveToDist).abs(),"up")
                        for i in (moveToDist).abs() do
                            toMoveDir.push("up")
                        end
                        toMoveDir.push("left")
                    else
                        checkCanMoveDown = checkCanMoveLine(vectorArr,toGoToVector,(moveToDist).abs(),"down")
                        for i in (moveToDist).abs() do
                            toMoveDir.push("down")
                        end
                        toMoveDir.push("left")
                    end
                end
            end
        else                 #----------- More Vertical
            if @vectorY < 0 #more below
                moveDown = move.call("down")
                if moveDown == "down"
                    toMoveDir.push("down")
                else
                    downRow.each_with_index{|tile,index|
                        if tile == true
                            canmoverow.push([index,(index - @vectorToMove.x).abs()])
                        end
                    }
                    canmoverow.sort_by{|tile|tile[1]}
                    toGoToVector = vector2.new(canmoverow[0][0],@vectorToMove.y+1)
                    moveToDist = @vectorToMove.x - toGoToVector.x
                    
                    if moveToDist > 0
                        checkCanMoveUp = checkCanMoveLine(vectorArr,toGoToVector,(moveToDist).abs(),"left")
                        for i in (moveToDist).abs() do
                            toMoveDir.push("left")
                        end
                        toMoveDir.push("down")
                    else
                        checkCanMoveDown = checkCanMoveLine(vectorArr,toGoToVector,(moveToDist).abs(),"right")
                        for i in (moveToDist).abs() do
                            toMoveDir.push("right")
                        end
                        toMoveDir.push("down")
                    end
                end
            else            #more above
                moveUp = move.call("up")
                if moveUp == "up"
                    toMoveDir.push("up")
                else
                    upRow.each_with_index{|tile,index|
                        if tile == true
                            canmoverow.push([index,(index - @vectorToMove.x).abs()])
                        end
                    }
                    canmoverow.sort_by{|tile|tile[1]}
                    toGoToVector = vector2.new(canmoverow[0][0],@vectorToMove.y-1)
                    moveToDist = @vectorToMove.x - toGoToVector.x
                    
                    if moveToDist > 0
                        checkCanMoveUp = checkCanMoveLine(vectorArr,toGoToVector,(moveToDist).abs(),"left")
                        for i in (moveToDist).abs() do
                            toMoveDir.push("left")
                        end
                        toMoveDir.push("up")
                    else
                        checkCanMoveDown = checkCanMoveLine(vectorArr,toGoToVector,(moveToDist).abs(),"right")
                        for i in (moveToDist).abs() do
                            toMoveDir.push("right")
                        end
                        toMoveDir.push("up")
                    end
                end
            end
        end
        return [toMoveDir,toGoToVector]
    end
    #returns an array of directions to target
    def buildPath(objectToFollow)
        tempVectorSelf = vector2.new(@vectorToMove.x,@vectorToMove.y)
        finalPath = []
        until tempVectorSelf.x == @vectorFollow.x && tempVectorSelf.y == @vectorFollow.y
            nextSquare = pathNext(tempVectorSelf,objectToFollow)
            nextSquarePath, nextSquareLocation = nextSquare[0], nextSquare[1]
            tempVectorSelf.x, tempVectorSelf.y = nextSquareLocation.x, nextSquareLocation.y
            finalPath.concat(nextSquarePath)
        end
        return finalPath
    end