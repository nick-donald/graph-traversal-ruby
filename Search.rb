class Node

end

class Searcher
  attr_reader :map
  attr_accessor :terrain, :start, :goal, :graph

  def initialize
    @map = []
    @path = []
    @counter = 0
  end

  def load_graph(graph)
    @graph = graph
  end

  def mark(pos)
    @map[pos[0]][pos[1]] = '#'
  end

  def load_labels(*labels)
    @labels = *labels
  end

  def dfs(vertex = 0)
    print "#{@labels[vertex]} - "
    # Mark vertex as 0
    edge = 0
    while edge < @graph.length
      @graph[vertex][edge] = 0
      edge += 1
    end

    # Look at each edge and call DFS
    edge = 0
    while edge < @graph.length
      if (@graph[edge][vertex] != 0 && edge != vertex)
        dfs(edge)
      end
      edge += 1
    end
  end

  def bfs(vertex = 0)
    relations = {}
    queue = [vertex]
    while queue.length > 0
      puts "hi"
      v = queue.pop
      # Mark as visited
      edge = 0
      while edge < @graph.length
        @graph[v][edge] = 0
        edge += 1
      end

      edge = 0
      while edge < @graph.length
        if (@graph[edge][v] != 0 && edge != v)
          relations[edge] = v
          return print_path(relations, edge) if edge == @labels.index(@goal)
          queue.push edge
        end
        edge += 1
      end
    end
  end

  def print_path(relations, edge)
    print "#{@labels[edge]} - "
    if (relations[edge])
      print_path(relations, relations[edge])
    end
  end
end

s = Searcher.new
G = [0,1,1,0,0,1,1,0,0,0],
    [1,0,0,0,0,0,0,0,0,0],
    [1,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,1,1,0,0,0,0],
    [0,0,0,1,0,1,1,1,1,0],
    [1,0,0,1,1,0,0,0,0,0],
    [1,0,0,0,1,0,0,0,0,0],
    [0,0,0,0,1,0,0,0,1,1],
    [0,0,0,0,1,0,0,1,0,0],
    [0,0,0,0,0,0,0,1,0,0]
s.load_graph(G)
s.load_labels("A", "B", "C", "D", "E", "F", "G", "H", "I", "J")
s.goal = "I"
# s.dfs(0)
puts s.bfs