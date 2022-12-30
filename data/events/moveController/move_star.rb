
class AStar
  # The `Node` class represents a single node in the grid. It has a position (x, y),
  # a cost for moving to that node (g_cost), and a heuristic estimate of the distance
  # to the goal (h_cost). It also has a reference to its parent node, which allows us
  # to trace our path back from the goal to the start.
  class Node
    attr_accessor :x, :y, :g_cost, :h_cost, :parent

    def initialize(x, y, g_cost, h_cost, parent)
      @x = x
      @y = y
      @g_cost = g_cost
      @h_cost = h_cost
      @parent = parent
      @blocked = false
    end
    def walkable?
      # Return false for nodes that are marked as blocked.
      return !@blocked
    end
    # The `f_cost` is the sum of the g_cost and h_cost, and represents the total
    # cost of moving to this node. We use this value to determine which node to
    # expand next, since we want to minimize the total cost.
    def f_cost
      @g_cost + @h_cost
    end
  end
  def self.heuristic_cost_estimate(start, goal)
    dx = (start.x - goal.x).abs
    dy = (start.y - goal.y).abs
    # Use the Euclidean distance heuristic to estimate the distance between the start
    # and goal nodes.
   return Math.sqrt(dx * dx + dy * dy)
  end

  # The `Grid` class represents the grid we are searching on. It has a 2D array of
  # nodes, which are either walkable or unwalkable. It also has the start and goal
  # nodes, which are represented as `Node` objects.
  class Grid
    attr_accessor :start, :goal, :nodes
    def initialize(width, height, start, goal, blocked_cells)
      # Initialize the 2D array of nodes, with all nodes having infinite g_cost and h_cost,
      # and no parent set.
      @nodes = Array.new(width) do |x|
        Array.new(height) do |y|
          Node.new(x, y, Float::INFINITY, Float::INFINITY, nil)
        end
      end
    
      # Set the start and goal nodes.
      @start = start
      @goal = goal
    
      # Set the blocked cells.
      blocked_cells.each do |x, y|
        @nodes[x][y].blocked = true
      end
    
      # Set the g_cost and h_cost for the start node.
      @start.g_cost = 0
      @start.h_cost = AStar.heuristic_cost_estimate(@start, @goal)
    end
    

    def [](x, y)
      # Return nil if x or y are out of bounds.
      return nil if x < 0 || x >= width || y < 0 || y >= height
      @nodes[x][y]
    end
    
    #---------------------------------------------------------
    def get_neighbors(current_node)
      neighbors = []
    
      # We check the nodes to the north, south, east, and west of the current node.
      # If the node is within the bounds of the grid and is walkable, we add it to
      # the list of neighbors.
      [-1, 1].each do |dx|
        x = current_node.x + dx
        y = current_node.y
        neighbor = self[x, y]
        if neighbor && neighbor.walkable?
          neighbors.push(neighbor)
        end
      end
      [-1, 1].each do |dy|
        x = current_node.x
        y = current_node.y + dy
        neighbor = self[x, y]
        if neighbor && neighbor.walkable?
          neighbors.push(neighbor)
        end
      end
    
      # We return the list of neighbors.
      return neighbors
    end
    
    #---------------------------------------------------------
    def width
      @nodes.length
    end
    

    def height
      @nodes[0].length
    end
    
  end
  
  # The `find_path` method is the main entry point for performing A* search. It takes
  # a `Grid` object and returns a list of `Node` objects representing the path from
  # start to goal, or `nil` if no path was found.
  
  
  def self.find_path(grid)
    # We use two lists to keep track of the nodes we need to expand: the open list
    # contains nodes that we have not yet considered, and the closed list contains
    # nodes that we have already expanded.
    open_list = []
    closed_list = []
  
    # We start by adding the start node to the open list.
    start = grid.start
    open_list.push(start)
  
    # Then we enter the main loop, which continues until we either find the goal or
    # exhaust the open list without finding a path.
    while !open_list.empty?
      # We sort the open list by f_cost, so that we always expand the node with the
      # lowest total cost first.
      open_list.sort_by! { |node| node.f_cost }
  
      # We remove the node with the lowest f_cost from the open list and add it to
      # the closed list. This node will be the one we expand next.
      current_node = open_list.shift
      closed_list.push(current_node)
      #puts("currentNode:(#{current_node.x},#{current_node.y})")
      # If the current node is the goal, we have found a path. We trace the path
      # back to the start and return it.
      goal = grid.goal
      if current_node.x == goal.x && current_node.y == goal.y
        path = []
        while current_node.parent
          path.unshift(current_node)
          current_node = current_node.parent
        end
        path.unshift(current_node)
        return path
      end
  
      # If we have not reached the goal, we expand the current node by adding its
      # neighbors to the open list.
      neighbors = grid.get_neighbors(current_node)
      neighbors.each do |neighbor|
        # If the neighbor is already in
            # If the neighbor is already in the closed list, we skip it.
        next if closed_list.include?(neighbor)

        # If the neighbor is not in the open list, we add it and update its
        # g_cost, h_cost, and parent values.
        if !open_list.include?(neighbor)
          open_list.push(neighbor)
          neighbor.g_cost = Float::INFINITY
          neighbor.h_cost = Float::INFINITY
          neighbor.parent = nil
        end

        # We calculate the cost of moving to the neighbor, which is the g_cost of
        # the current node plus the cost of moving from the current node to the
        # neighbor.
        cost = current_node.g_cost + AStar.heuristic_cost_estimate(current_node, neighbor)

        # If the cost of moving to the neighbor is lower than its current g_cost,
        # we update the g_cost and parent values of the neighbor.
        if cost < neighbor.g_cost
          neighbor.g_cost = cost
          neighbor.parent = current_node

          # We also update the h_cost of the neighbor based on the new g_cost.
          neighbor.h_cost = AStar.heuristic_cost_estimate(neighbor, goal)
          # puts "Updated g_cost and h_cost for neighbor #{neighbor.x},#{neighbor.y},to G: #{neighbor.g_cost},H: #{neighbor.h_cost}"
        end
      end
    end
  end

  def self.new_path(start,goal)
    newNode = ->(loc){
      return Node.new(loc[0], loc[1], 0, 0, nil)
    }
    map = $scene_manager.currentScene.currentMap
    blockedSpots = $scene_manager.currentScene.currentMap.blockedTiles
    grid = Grid.new(map.w, map.h, newNode.call(start), newNode.call(goal), blockedSpots)
    path = self.find_path(grid)
    currPath = []
    path.each{|node|
      currPath.push([node.x,node.y])
    }
    return currPath
  end

  def self.check_maps(mapsArr)
    newNode = ->(loc){
        return Node.new(loc[0], loc[1], 0, 0, nil)
    }
    foundPaths = Hash.new

    mapsArr.each_with_index{|map,index|
        blockedSpots = []
        map.blockedTiles.each{|tile|
            blockedSpots.push([tile.x,tile.y])
        }
        (0...map.w).each do |start_x|
            (0...map.h).each do |start_y|
                (0...map.w).each do |end_x|
                    (0...map.h).each do |end_y|
                      #if start_x != end_x and start_y != end_y
                        startLoc = [start_x,start_y]
                        endLoc = [end_x,end_y]
                        # puts("start:(#{startLoc[0]},#{startLoc[1]})")
                        # puts("end:(#{endLoc[0]},#{endLoc[1]})")
                        # puts("creating grid..")
                        grid = Grid.new(map.w, map.h, newNode.call(startLoc), newNode.call(endLoc), blockedSpots)
                        # Find a path on the grid.
                        # puts("finding the path..")
                        path = self.find_path(grid)
                        # Print the path, if one was found.
                        if path
                            puts "Found a path! MAP: #{index},F: (#{startLoc[0]},#{startLoc[1]}),T: (#{endLoc[0]},#{endLoc[1]})"
                            currPath = []
                            path.each{|node|
                              currPath.push([node.x,node.y])
                            }
                            foundPaths["#{index},#{startLoc[0]},#{startLoc[1]},#{endLoc[0]},#{endLoc[1]}"] = currPath

                        else
                            puts "NO path was found. MAP: #{index+1},F:(#{startLoc[0]},#{startLoc[1]}),T: (#{endLoc[0]},#{endLoc[1]})"
                        end
                      #end
                    end
                end
            end
        end
    }
    return foundPaths
end

end

