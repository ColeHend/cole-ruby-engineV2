class Move_NPC
    include Animate
    attr_accessor :moveArray
    def initialize(objectToMove,moveType,sprite,mapNum)
        @objectToMove = objectToMove
        @moveType = moveType
        @sprite = sprite
        @mapNum = mapNum
        @evtName = ""
        @moveArray = []
        @vectorToMove = Vector2.new(@objectToMove.x/32,@objectToMove.y/32)
        @vectorFollow 
        @vectorX
        @vectorY
        @state = "stop"
        speed = 0.25
        time = 10
        @facing = "down"
        @moveLeft = ->(){
            @facing = "left"
            move(@facing,speed,time)
        }
        @moveRight = ->(){
            @facing = "right"
            move(@facing,speed,time)
        }
        @moveUp = ->(){
            @facing = "up"
            move(@facing,speed,time)
        }
        @moveDown = ->(){
            @facing = "down"
            move(@facing,speed,time)
        }
    end
    def setState()
        case @state
        when "moving"
            # puts("player state: #{@state}")
            @sprite.draw()
            draw_character(@sprite, @facing ,10)
        when "stop"
            @sprite.draw()
            draw_character(@sprite,"#{@facing}Stop",1)
        end
    end
    def move(direction,speed=1,timing = 6)
        vector = Vector2.new(0,0)
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

        newXPos = @sprite.x + (vector.x * 4)
        newYPos = @sprite.y + (vector.y * 4)
        checkCollision = collisionDetect.check_surrounding(direction)
        if checkCollision != false
            if checkCollision[0][0].eventName == @evtName
                checkCollision = false
            end
        end
        if vector.y > 0
            # puts("#{direction}: #{@sprite.y < ($scene_manager.currentMap.h * 31)}")
            if @sprite.y < ($scene_manager.currentMap.h * 31)
                if checkCollision == false
                    @state = "moving"
                    @sprite.y = newYPos
                else
                    puts(collisionDetect.check_surrounding(direction)[0][0].eventName)
                end
            end
        elsif vector.y < 0
            # puts("#{direction}: #{@sprite.y > 0}")
            if @sprite.y > 0
                if checkCollision == false
                    @sprite.y = newYPos
                    @state = "moving"
                else
                    puts(collisionDetect.check_surrounding(direction)[0][0].eventName)
                end
            end
        elsif vector.x > 0
            # puts("#{direction}: #{@sprite.x < ($scene_manager.currentMap.w * 31)}")
            if @sprite.x < ($scene_manager.currentMap.w * 31)
                if checkCollision == false
                    @sprite.x = newXPos
                    @state = "moving"
                else
                    puts(collisionDetect.check_surrounding(direction)[0][0].eventName)
                end
            end
        elsif vector.x < 0
            # puts("#{direction}: #{@sprite.x < ($scene_manager.currentMap.w * 31)}")
            if @sprite.x > 0
                if checkCollision == false
                    @sprite.x = newXPos
                    @state = "moving"
                else
                    puts(collisionDetect.check_surrounding(direction)[0][0].eventName)
                end
            end
        else 
            @state = "stop"
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
    def buildPathStar(objectToFollow)
        currMap = @mapNum - 1
        endVect = Vector2.new(objectToFollow.x/32,objectToFollow.y/32)
        startLoc = [@vectorToMove.x.to_i,@vectorToMove.y.to_i]
        endLoc = [endVect.x.to_i,endVect.y.to_i]
        thePath = $scene_manager.allPaths["#{currMap},#{startLoc[0]},#{startLoc[1]},#{endLoc[0]},#{endLoc[1]}"]
        updatedPath = []
        currNode = startLoc
        thePath.each_with_index{|node,index|
            xPos = node[0] - currNode[0]
            yPos = node[1] - currNode[1]
           if yPos < 0 && xPos == 0 #up
            updatedPath.push("up")
           elsif yPos > 0 && xPos == 0 #down
            updatedPath.push("down")
           elsif yPos == 0 && xPos < 0 #left
            updatedPath.push("left")
           elsif yPos == 0 && xPos > 0 #right
            updatedPath.push("right")
           end
           currNode = node
        }
        # puts("NPC Path: #{updatedPath}")
        return updatedPath
    end
    def follow_path(objectToFollow,facing)
        if objectToFollow != nil

            toMoveDirection = buildPathStar(objectToFollow)
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
    def set_move(objectToFollow=nil,facing=nil,daEvent=nil)
        
        @objectToMove.x, @objectToMove.y = daEvent.x, daEvent.y
        @sprite.x, @sprite.y = daEvent.x, daEvent.y
        @vectorToMove = Vector2.new(@objectToMove.x/32,@objectToMove.y/32)
        @evtName = daEvent.eventName
        case @moveType
        when "random"
            @moveUpdate = ->(){
            }
            if @moveArray.length == 0
                random_path()
            end
        when "follow"
            if objectToFollow != nil && facing != nil
                @moveArray.clear()
                follow_path(objectToFollow,facing)
                # if @moveArray.length == 0
                #     follow_path(objectToFollow,facing)
                # end
            end
        when "none"
            @moveUpdate = ->(){}
        end
    end
    def update
        @impassArr = $scene_manager.scenes["map"].currentMap.blockedTiles
        @passMap = Array.new($scene_manager.scenes["map"].currentMap.w,Array.new($scene_manager.scenes["map"].currentMap.h,true))

        if @moveArray.length > 0
            move_execute()
        else
            @state = "stop"
        end
    end

    def draw
        setState()
        
    end
end