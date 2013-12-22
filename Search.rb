class Searcher
  attr_reader :map
  attr_accessor :terrain, :start, :goal

  def initialize
    @map = []
    @path = []
  end

  def load(file)
    file = File.open(file, "r") do |f|
      f.read
    end

    file.each_line do |line|
      row = []
      line.scan(/[@*.^~X]/) do |r|
        case r
        when /[@.X]/
          row << 1
        when /\*/
          row << 2
        when /\^/
          row << 3
        else
          row << 0
        end
      end
      startX = line.index('@')
      endX = line.index('X')
      @start = [@map.length, startX] if startX
      @goal = [@map.length, endX] if endX
      @map << row
    end
  end

  def import_rules(rules)
    @terrain = Hash.new
    arr = rules.split(', ')
    arr.each do |r|
      vals = r.split('=')
      @terrain[vals[0]] = vals[1]
    end
    @terrain
  end

  def print_map
    @map.each do |map_line|
      map_line.each do |e|
        print "#{e} "
      end
      print "\n"
    end
  end

  def dfs(pos = @start)
    mark(pos)
    adjs = adjacents(pos)
    puts adjs.count
    adjs.each do |a|
      puts @map[a[1], a[0]] if @map[a[1], a[0]]
    end
  end

  def adjacents(pos)
    res = []
    res << [pos[0] - 1, pos[1]] # Up
    res << [pos[0] - 1, pos[1] + 1] # 
    res << [pos[0], pos[1] + 1]
    res << [pos[0] + 1, pos[1] + 1]
    res << [pos[0] + 1, pos[1]]
    res << [pos[0] - 1, pos[1] - 1]
    res << [pos[0], pos[1] - 1]
    res << [pos[0] - 1, pos[1] - 1]
    # puts res
    # res.each do |re|
    #   puts "#{re[0]}, #{re[1]}\n"
    # end
  end

  def mark(pos)
    @map[pos[0]][pos[1]] = '#'
  end
end

s = Searcher.new
s.load('simple_small_map.txt')
s.dfs
# s.print_map
# puts s.import_rules "~=0, .=1, *=2, ^=3, @=user, X=goal"