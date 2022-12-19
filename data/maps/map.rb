class Map_Base
    attr_accessor :w, :h, :events, :theMap, :mapTiles,:playersDraw, :blockedTiles
    def initialize(tileset,width,height,file,layers=5) 
        @mapTiles = tileset
        @events = []
        @w = width
        @h = height
        @layers = layers
        @playerDraw = ->(){
            
        }
        @runEffects = []
        @theMap = Map.new(32, 32, width, height, 800, 600, false, true)
        @mapfile = file
        @camera_x = @camera_y = 0
        @player = $scene_manager.scene["player"]
        draw_tile_loop()
        @blockedTiles = @mapTiles.impassableTiles
        @frameNum = 0
    end
    def currentBlockedTiles()
        @blockedTiles = @mapTiles.impassableTiles
        @events.each{|e|
            if e.passible == false
                @blockedTiles.push(e)
            end
        }
    end
    def draw_tile_loop()
        mapArrayY = @mapfile['draw']
        @theMapRecord = Gosu.record(@width*32,@height*32) do |x, y|
          if @mapfile != nil
            mapArrayY.each_with_index {|mapArrayX, yIndex|
              mapArrayX.each_with_index {|tile, xIndex|
                for num in 0..(@layers*0.5).ceil() do
                    if tile[num] != nil && tile[num] != "nil"
                      @mapTiles.draw_tile(tile[num],yIndex,xIndex,0)
                    end
                end
              }
            }
          end
        end
        @theMapRecordTop = Gosu.record(@width*32,@height*32) do |x, y|
            if @mapfile != nil
              mapArrayY.each_with_index {|mapArrayX, yIndex|
                mapArrayX.each_with_index {|tile, xIndex|
                  for num in (@layers*0.5).ceil()..@layers do
                      if tile[num] != nil && tile[num] != "nil"
                        @mapTiles.draw_tile(tile[num],yIndex,xIndex,0)
                      end
                  end
                }
              }
            end
          end
    end

    def update
        @camera_x = [[(@player.x) - 800 / 2, 0].max, ((@w * 32) + 32) - 800].min
        @camera_y = [[(@player.y) - 600 / 2, 0].max, ((@h * 32) + 32) - 600].min
        @events.each_with_index{|evt,index|
            if evt.stats.currentHP <= 0
                @events.delete_at(index)
            end
        }
        if @runEffects.length > 0
          @runEffects.each {|effect|
              effect.draw(nil,1,1,0xff,0xffffff,nil)
          }
        end
        if @frameNum >= 60
            currentBlockedTiles()
            @frameNum = 0
        end
    end

    def draw()
        @frameNum += 1
        Gosu.translate(-@camera_x, -@camera_y) do
            @theMapRecord.draw(0,0,0)
            @playersDraw.call()
            if @events.length > 0
                @events.each {|e|
                    if @player.y >= e.y
                        e.draw()
                    elsif @player.y < e.y
                        e.draw()
                    end
                }
            else
                @player.draw
            end
            @theMapRecordTop.draw(0,0,0)
            if @runEffects.length > 0
              @runEffects.each_with_index {|effect,index|
                  if effect.dead
                      @runEffects.delete_at(index)
                  else
                      effect.update
                  end
              }
          end
        end
    end
end