require 'gosu'

class AStar
  # The `Node` class represents a single node in the grid. It has a position (x, y),
  # a cost for moving to that node (g_cost), and a heuristic estimate of the distance
  # to the goal (h_cost). It also has a reference to its parent node, which allows us
  # to trace our path back from the goal to the start.
  class Node
    attr_reader :x, :y, :g_cost, :h_cost, :parent

    def initialize(x, y, g_cost, h_cost, parent)
      @x = x
      @y = y
      @g_cost = g_cost
      @h_cost = h_cost
      @parent = parent
    end

    # The `f_cost` is the sum of the g_cost and h_cost, and represents the total
    # cost of moving to this node. We use this value to determine which node to
    # expand next, since we want to minimize the total cost.
    def f_cost
      @g_cost + @h_cost
    end
  end

  # The `Grid` class represents the grid we are searching on. It has a 2D array of
  # nodes, which are either walkable or unwalkable. It also has the start and goal
  # nodes, which are represented as `Node` objects.
  class Grid
    def initialize(width, height, start, goal, blocked_cells)
      @nodes = Array.new(width) do |x|
        Array.new(height) do |y|
          Node.new(x, y, Float::INFINITY, Float::INFINITY, nil)
        end
      end

      @start = start
      @goal = goal

      blocked_cells.each do |x, y|
        @nodes[x][y] = nil
      end

      @start.g_cost = 0
      @start.h_cost = heuristic_cost_estimate(@start, @goal)
    end

    def [](x, y)
      return nil if x < 0 || x >= width || y < 0 || y >= height
      @nodes[x][y]
    end

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
    open_list.push(grid.start)

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

      # If we have reached the goal, we can return the path by following the parent
      # references back from the goal node.
      if current_node == grid.goal
        path = []
        while current_node
          path.unshift(current_node)
          current_node = current_node.parent
        end
        return path
      end

      # If we have not reached the goal, we need to consider the neighbors of the
      # current node.
      neighbors = []
      [-1, 0, 1].each do |dx|
        [-1, 0, 1].each do |dy|
          # We don't want to consider the current node itself as a neighbor, so we
          # skip it if dx and dy are both 0.
          next if dx == 0 && dy == 0
          # We also skip nodes that are outside the grid or are unwalkable.
          neighbor = grid[current_node.x + dx, current_node.y + dy]
          next if !neighbor || !neighbor.walkable?
          # If the neighbor is already in the closed list, we skip it because we have
          # already expanded it.
          next if closed_list.include?(neighbor)
          # If the neighbor is not in the open list, we add it and update its g_cost,
          # h_cost, and parent values.
          if !open_list.include?(neighbor)
            open_list.push(neighbor)
            neighbor.g_cost = Float::INFINITY
            neighbor.h_cost = Float::INFINITY
          end
          # We update the g_cost, h_cost, and parent values for the neighbor if the path
          # through the current node is cheaper than the previous path.
        end
       end
    end
  end
end

#usage example

def check_maps(mapsArr)
    newNode = ->(loc){
        return AStar::Node.new(loc[0], loc[1], 0, 0, nil)
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
                       if start_x != end_x && start_y != end_y
                        startLoc = [start_x,start_y]
                        endLoc = [end_x,end_y]
                        grid = AStar::Grid.new(map.w, map.h, newNode.call(startLoc), newNode.call(endLoc), blockedSpots)
                        # Find a path on the grid.
                        path = AStar.find_path(grid)
                        # Print the path, if one was found.
                        if path
                            puts "Found a path!"
                            foundPaths["#{index},#{startLoc[0]},#{startLoc[1]},#{endLoc[0]},#{endLoc[1]}"] = path 
                        else
                            puts "No path was found."
                        end
                       end
                    end
                end
            end
        end
    }
    return foundPaths
end



