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
        @vectorToMove = Vector2.new(@sprite.x/32,@sprite.y/32)
        @lastPathEnd = [(@sprite.x/32).to_i,(@sprite.y/32).to_i]
        @vectorFollow 
        @vectorX
        @vectorY
        @state = "stop"
        speed = 0.25
        @sp = speed 
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
        collisionDetect = MoveCollision.new(@objectToMove,false)
        
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
        
        checkRB = {
            "down"=>120, "up"=>1,
            "right"=>6, "left"=>6
        }
        checkCollision = collisionDetect.check_surrounding(direction,checkRB[direction])
        if checkCollision != false
            blockMove = false
            checkCollision[0].each{|e|
                if e.eventName != @evtName
                    blockMove = true
                end
            }
            if !blockMove
                checkCollision = blockMove
            end
        end
        
        if vector.y > 0
            if @objectToMove.y < ($scene_manager.currentMap.h * 31)
                if checkCollision == false
                    @state = "moving"
                    @sprite.y = newYPos
                end
            end
        elsif vector.y < 0
            if @objectToMove.y > 0
                if checkCollision == false
                    @sprite.y = newYPos
                    @state = "moving"
                end
            end
        elsif vector.x > 0
            if @objectToMove.x < ($scene_manager.currentMap.w * 31)
                if checkCollision == false
                    @sprite.x = newXPos
                    @state = "moving"
                end
            end
        elsif vector.x < 0
            if @objectToMove.x > 0
                if checkCollision == false
                    @sprite.x = newXPos
                    @state = "moving"
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
   
    def buildPathStar(objectToFollow)
        currMap = @mapNum - 1
        daMap = $scene_manager.currentMap
        endVect = Vector2.new(objectToFollow.x/32,objectToFollow.y/32)
        startLoc = [@vectorToMove.x.to_i,@vectorToMove.y.to_i]
        endLoc = [endVect.x.to_i,endVect.y.to_i]
        if endLoc[0] >= 0 && endLoc[1] >= 0
            if endLoc[0] <= daMap.w && endLoc[1] <= daMap.h
                puts("building a new path for #{@evtName}")
                thePath = $scene_manager.allPaths["#{currMap},#{startLoc[0]},#{startLoc[1]},#{endLoc[0]},#{endLoc[1]}"]
                thePath.pop()
                updatedPath = thePath[-1]
                currNode = startLoc
                thePath.each_with_index{|node,index|
                    xPos = node[0] - currNode[0]
                    yPos = node[1] - currNode[1]
                    numTimes = (32 / (0.25 * 4)).to_i
                   if yPos < 0 && xPos == 0 #up
                    numTimes.times{
                        @moveArray.push(@moveUp)
                    }
                   elsif yPos > 0 && xPos == 0 #down
                    numTimes.times{
                        @moveArray.push(@moveDown)
                    }
                   elsif yPos == 0 && xPos < 0 #left
                    numTimes.times{
                        @moveArray.push(@moveLeft)
                    }
                   elsif yPos == 0 && xPos > 0 #right
                    numTimes.times{
                        @moveArray.push(@moveRight)
                    }
                   end
                   currNode = node
                }
                return updatedPath
            end
        end
        return []
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
    def arrived(nowVector,lastPathEnd)
        if lastPathEnd.is_a?(Array) == false
            lastPathEnd = [lastPathEnd.x,lastPathEnd.y]
        end
        if (lastPathEnd[0] + 1) == nowVector.x && lastPathEnd[1] == nowVector.y
            return true
        elsif (lastPathEnd[0] - 1) == nowVector.x && lastPathEnd[1] == nowVector.y
            return true
        elsif (lastPathEnd[0]) == nowVector.x && lastPathEnd[1] + 1 == nowVector.y
            return true
        elsif (lastPathEnd[0]) == nowVector.x && lastPathEnd[1] - 1 == nowVector.y
            return true
        elsif ((lastPathEnd[0]) == nowVector.x && lastPathEnd[1] == nowVector.y)
            return true
        end
        return false
    end
    def update_move(daEvent=nil)
        
        @objectToMove.x, @objectToMove.y = daEvent.x, daEvent.y
        @sprite.x, @sprite.y = @objectToMove.x, @objectToMove.y
        facing = daEvent.facing
        objectToFollow = daEvent.targetObject
        
        @vectorToMove = Vector2.new(@objectToMove.x/32,@objectToMove.y/32)
        @evtName = daEvent.eventName
        if @moveArray.length == 0 
            case daEvent.moveType
            when "random"
                random_path()
            when "follow"
                daX, daY = objectToFollow.x/32, objectToFollow.y/32
                tarVec = Vector2.new(daX.to_i,daY.to_i)
                nowVector = Vector2.new(@sprite.x/32,@sprite.y/32)
                if objectToFollow != nil && facing != nil
                    # puts("--------Arrived-------")
                    # puts(arrived(nowVector,@lastPathEnd))
                    # puts("(#{nowVector.x},#{nowVector.y})")
                    # puts("(#{@lastPathEnd[0]},#{@lastPathEnd[1]})")
                    # puts("----------------------")
                    if arrived(nowVector,tarVec) == false && arrived(nowVector,@lastPathEnd) == true
                        # puts("---------------------")
                        # puts("target: (#{tarVec.x},#{tarVec.y})")
                        # puts("before")
                        # puts("---------")
                        # puts("lastPath:(#{@lastPathEnd[0]},#{@lastPathEnd[1]})")
                        # puts("nowVector: (#{nowVector.x},#{nowVector.y})")
                        @lastPathEnd = buildPathStar(objectToFollow)
                        # puts("after")
                        # puts("---------")
                        # puts("lastPath:(#{@lastPathEnd[0]},#{@lastPathEnd[1]})")
                        # puts("nowVector: (#{nowVector.x},#{nowVector.y})")
                    end
                    
                end
            end
        end
    end
    def update
        @impassArr = $scene_manager.scenes["map"].currentMap.blockedTiles
        @passMap = Array.new($scene_manager.currentMap.w,Array.new($scene_manager.currentMap.h,true))
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