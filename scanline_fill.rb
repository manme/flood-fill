
# Flood fill algorithm based on scan line way
class ScanlineFill
  attr_accessor :stack, :width, :height, :array, :new_color, :old_color

  # dir: -1: above the previous seed, 1:below the previous seed, 0:no previous seed
  Seed = Struct.new(:start_x, :end_x, :y, :dir, :is_scan_left, :is_scan_right)

  def fill(img_array, x, y, color)

    self.stack = []
    self.array = img_array
    self.new_color = color
    self.width = array.size
    self.height = array[0].size

    # check conditions
    return array unless in_bounds?(x, y)
    self.old_color = array[x][y]

    # fill first cell
    fill_array(x, y)

    # add this cell to stack
    stack.push(Seed.new(x, x, y, 0, true, true))

    iterate_stack_horizontally
    array
  end

  # we going to left and to right from start_x and from end_x respectively
  def iterate_stack_horizontally
    begin
      seed = stack.pop
      start_x = seed.start_x
      end_x = seed.end_x

      start_x = left_of(seed)
      end_x = right_of(seed)

      new_vertical_lines(seed, start_x, end_x)

    end while(stack.any?)
  end

  # fill cells left of start_x
  def left_of(seed)
    start_x = seed.start_x

    if(seed.is_scan_left)
      while(can_fill?(start_x - 1, seed.y)) do
        start_x -= 1
        fill_array(start_x, seed.y)
      end
    end

    start_x
  end

  # fill cells right of end_x
  def right_of(seed)
    end_x = seed.end_x

    if(seed.is_scan_right)
      while(can_fill?(end_x + 1, seed.y)) do
        end_x += 1
        fill_array(end_x, seed.y)
      end
    end

    end_x
  end

  # move up and down, to fill new lines
  def new_vertical_lines(seed, start_x, end_x)
    if(seed.y > 0)
      add_line(start_x, end_x, seed.y - 1, -1)
    end

    if(seed.y < height - 1)
      add_line(start_x, end_x, seed.y + 1, 1)
    end
  end

  def add_line(start_x, end_x, y, dir)
    line_start_x = -1 # x position of new line

    # we can't fill outside bound of parent line
    for x in start_x..end_x do
      if(can_fill?(x, y))
        fill_array(x, y)
        line_start_x = x if line_start_x < 0 # start a new line if we haven't already
      elsif(line_start_x >= 0)
        # we started to fill this line and can't fill on right side, thus is_scan_right=false
        stack.push(Seed.new(line_start_x, x, y, dir, line_start_x == start_x, false))
        line_start_x = -1 # reset start_x of seed
      end
    end

    # save seed if last operation was filling
    if(line_start_x >= 0)
      stack.push(Seed.new(line_start_x, x, y, dir, line_start_x == start_x, true))
    end
  end

  def can_fill?(x, y)
    return false unless in_bounds?(x, y)
    array[x][y] == old_color
  end

  def in_bounds?(x, y)
    return false if (x >= width || x < 0)
    return false if (y >= height || y < 0)
    true
  end

  def fill_array(x, y)
    array[x][y] = new_color
  end
end

