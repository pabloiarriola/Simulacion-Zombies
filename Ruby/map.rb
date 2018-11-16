class MapBoundaryError < RuntimeError
end
class MapCollisionError < RuntimeError
end

def distance_sq(x1, y1, x2, y2)
  dx = (x2 - x1);
  dy = (y2 - y1);
  dist = dx * dx + dy * dy;
end
 
class Map
  attr_reader :height, :width, :grid, :entities
  def initialize(width, height)
    @width = width
    @height = height
    @grid = []
    @entities = []

    # init grid
    (0..@width).each do |x|
      @grid[x] = []
    end

    @entities = []
  end

  def has_living()
    for e in @entities
      return true if e.is_a?(Human)
    end
    return false
  end

  def add(entity, x, y)
    @entities << entity

    pos(entity, x, y)
  end

  # finds a random, unoccupied point on the map
  def get_free()
    tries = 0
    while true
      tries += 1
      x = rand(@width - 1)
      y = rand(@height - 1)
      return [x, y] if !@grid[x][y]
    end
  end

  def pos(entity, x, y)
    # bounds checking
    if x >= @width || x < 0
      raise MapBoundaryError.new("x out of bounds")
    end
    if y >= @height || y < 0
      raise MapBoundaryError.new("y out of bounds")
    end

    # collision detection
    if @grid[x][y] && @grid[x][y] != entity
      raise MapCollisionError.new("#{entity.id} moved to collide with #{@grid[x][y].id} at [#{x},#{y}]")
    end

    if entity.on_map?
      @grid[entity.x][entity.y] = nil
    end

    @grid[x][y] = entity
    entity.pos(x, y)

    return true
  end

  def turn
    @entities.each do |entity|
      entity.turn()
    end
  end

  def neighborhood(x, y)
    nbh = []
    nbh << [x, y + 1]
    nbh << [x - 1, y + 1]
    nbh << [x - 1, y]
    nbh << [x - 1, y - 1]
    nbh << [x, y - 1]
    nbh << [x + 1, y - 1]
    nbh << [x + 1, y]
    nbh << [x + 1, y + 1]

    nbh.delete_if { |pt| pt[0] < 0 || pt[0] > @width - 1 || 
      pt[1] < 0 || pt[1] > @height - 1 }
  end

  def neighbors(x, y)
    n = neighborhood(x, y).map do |pt| 
      z = @grid[pt[0]][pt[1]]
      z if z.is_a? Entity
    end
    n.delete_if { |e| !e }
  end

  def delete(x, y)
    @entities.delete(@grid[x][y])
    @grid[x][y] = nil
  end

  def to_s
    s = "\n"

    for y in (@height - 1).downto(0)
      for x in 0..(@width - 1)
        if @grid[x][y]
          s += @grid[x][y].char
        else 
          s += "."
        end
      end
      s = s + "\n"
    end

    return s
  end
end

