class Move_NPC
    def initialize(objectToMove,moveType)
        @objectToMove = objectToMove
        @moveType = moveType
        @moveUpdate = ->(){}
        @moveDraw = ->(){}
        @moveArray = []
        @vectorToMove = Vector2.new(@objectToMove.x/32,@objectToMove.y/32)
        @vectorFollow 
        @vectorX
        @vectorY
        @impassArr = $scene_manager.currentMap.blockedTiles
        @passMap = Array.new($scene_manager.currentMap.w,Array.new($scene_manager.currentMap.h,true))
        @impassArr.each{|e|#make impass row
            @passMap[e.y][e.x] = false
        }
        speed = 0.25
        time = 10
        @moveLeft = ->(){
            facing = "left"
            move(facing,speed,time)
        }
        @moveRight = ->(){
            facing = "right"
            move(facing,speed,time)
        }
        @moveUp = ->(){
            facing = "up"
            move(facing,speed,time)
        }
        @moveDown = ->(){
            facing = "down"
            move(facing,speed,time)
        }
    end
    def move(direction,speed=1,timing = 6)
        vector = vector2.new(0,0)
        collisionDetect = MoveCollision.new(@objectToMove)
        
        case direction
            when "down"
                vector.y = speed
            when "up"
                vector.y = -speed
            when "right"
                vector.x = speed
            when "left"
                vector.x = -speed
            when "none"
                vector.x = 0
                vector.y = 0
        end

        newXPos = @objectToMove.x + (vector.x * 4)
        newYPos = @objectToMove.y + (vector.y * 4)
        if vector.y > 0
            if collisionDetect.check_surrounding("down",@objectToMove) == false
                @objectToMove.y = newYPos
                draw_character(@objectToMove, "down",timing)
            end
        elsif vector.y < 0
            if collisionDetect.check_surrounding("up",@objectToMove) == false
                @objectToMove.y = newYPos
                draw_character(@objectToMove, "up",timing)
            end
        elsif vector.x > 0
            if collisionDetect.check_surrounding("right",@objectToMove) == false
                @objectToMove.x = newXPos
                draw_character(@objectToMove, "right",timing)
            end
        elsif vector.x < 0
            if collisionDetect.check_surrounding("left",@objectToMove) == false
                @objectToMove.x = newXPos
                draw_character(@objectToMove, "left",timing)
            end
        else 
            draw_character(@objectToMove, "#{direction}Stop",timing)
        end
        
    end
    def move_execute()
        @moveArray[0].call()
        @moveArray.delete_at(0)
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

    def follow_path(objectToFollow,facing)
        if objectToFollow != nil

            toMoveDirection = buildPath(objectToFollow)
            toMoveDirection.each{|dir|
                case dir
                    when "up"
                        @moveArray.push(@moveUp)
                    when "down"
                        @moveArray.push(@moveDown)
                    when "left"
                        @moveArray.push(@moveLeft)
                    when "right"
                        @moveArray.push(@moveRight)
                end
            }
        end
    end
    def random_path(moveDist=rand(5))
        randomNum = rand(4)
        moveWaitTime = (Gosu::milliseconds()/100 % 32)
        #puts("RandomMoveTime: #{moveWaitTime}")
        if (moveWaitTime == 0)
            case randomNum
            when 0
                moveDist.times{@moveArray.push(@moveRight) }
            when 1
                moveDist.times{@moveArray.push(@moveUp) }
            when 2
                moveDist.times{@moveArray.push(@moveLeft) }
            when 3
                moveDist.times{@moveArray.push(@moveDown)}
            end
            @delayStart = Gosu::milliseconds()
        end
    end
    def set_move(objectToFollow=nil,facing=nil)
        case @moveType
        when "random"
            @moveUpdate = ->(){
                random_path()
            }
        when "follow"
            if objectToFollow != nil && facing != nil
                @moveUpdate = ->(){
                    follow_path(objectToFollow,facing)
                }
            end
        when "none"
            @moveUpdate = ->(){}
        end
    end
    def update
        @impassArr = $scene_manager.currentMap.blockedTiles
        if @moveArray.length == 0
            @moveUpdate.call()
        end
    end

    def draw
        if @moveArray.length > 0
            move_execute()
        end
    end
end