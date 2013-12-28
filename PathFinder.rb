class Node
  attr_accessor :pos, :marked, :parent

  def initialize(pos)
    @pos = pos
  end

  def mark
    @marked = true
  end

  def set_parent(node)
    @parent = node
  end
end

class PathFinder
  attr_accessor :map, :graph, :start, :goal

  def initialize(file)
    @map = File.open(file, "r") do |f|
      f.read
    end
    @graph = []
    parse @map
  end

  def parse(map)
    @map.each_line do |line|
      row = []
      line.scan(/[@\.\~\*\^X]/) do |char|
        case char
        when /[@X\.\*\^]/
          row << 1
        when /~/
          row << 0
        end
      end
      startX = line.index('@')
      goalX = line.index('X')

      @start = [@graph.length, startX] if startX
      @goal = [@graph.length, goalX] if goalX

      @graph << row
    end
  end

  def adjacents(pos)
    res = []
    row = pos[0]
    col = pos[1]
    ((row - 1)..(row + 1)).each do |r|
      ((col - 1)..(col + 1)).each do |c|
        if ((c >= 0 && r >= 0 && c < @graph.length && r < @graph.length) && [r,c] != pos)
          res << [r, c]
        end
      end
    end
    res
  end

  def dfs_catch(pos = [0,0])
    # p @graph
    @graph[pos[0]][pos[1]] = '#'
    adjs = adjacents(pos)
    adjs.each do |a|
      if (@graph[a[0]][a[1]] == '#' || @graph[a[0]][a[1]] == 0)
        next
      elsif (a == @goal)
        puts "success"
        p a
        throw :found, a
      else
        # graph_print
        dfs_catch(a)
      end
    end
  end

  def dfs
    start_time = Time.now.to_i
    catch (:found) do
      dfs_catch
    end
    end_time = Time.now.to_i
    puts "Execution Time: #{end_time - start_time} ms"
  end

  def bfs(pos = [0,0])
    graph_print
    start = Node.new(pos)
    queue = [start]
    while queue.length > 0
      item = queue.pop
      item_pos = item.pos
      @graph[item.pos[0]][item.pos[1]] = '#'
      adjs = adjacents(item_pos)
      adjs.each do |a|
        if @graph[a[0]][a[1]] == 1
          node = Node.new(a)
          node.parent = item
          if (a == @goal)
            puts "success"
            display_path node
            graph_print
            return
          else
            queue.push(node)
          end
        end
      end
    end
  end

  def display_path(node)
    while node.parent
      p node.pos
      node = node.parent
    end
  end

  def graph_print
    @graph.each do |col|
      col.each do |cell|
        print "#{cell} "
      end
      print "\n"
    end
    puts "--------"
  end
end

finder = PathFinder.new("big_map.txt")
finder.bfs