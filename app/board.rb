require 'matrix'

class Matrix
  # Make Matrix mutable
  public :"[]=", :set_element, :set_component

  # The Matrix documentation on ruby-doc.org appears to be incorrect; method argument orders are not actually reversed as: y,x / row,column. Rather, everything is in x,y / column,row form

  alias_method :width, :row_size # The number of rows
  alias_method :height, :column_size # The number of columns

  def to_a_of_rows
    # Transpose (swap axis) so we are given an array of rows rather than an array of columns
    transpose.to_a
  end

  def render h_separator, v_separator
    to_a_of_rows.map { |row| row.join h_separator }.join v_separator
  end

  # Allow prevention of Matrix's handling of negative coordinates
  def coordinates_valid? x, y
    (0..width-1 ).include?(x) &&
    (0..height-1).include?(y)
  end
end

class String
  def remove_nth_char_from_lines n
    self.split("\n").map do |line|
      line.chars.select.with_index { |_,i| (i+1) % n != 0 }.join
    end.join "\n"
  end
end

class Board
  def initialize width, height
    @tiles = Matrix.build(width, height) { new_tile }
  end

  def player
    @player ||= (
      player_tile = @tiles.select { |t| t.solid_inhabitant.is_a? Player }.first
      player_tile && player_tile.solid_inhabitant
    )
  end

  def width
    @tiles.row_size
  end

  def height
    @tiles.column_size
  end

  def [] x, y
    if @tiles.coordinates_valid? x, y
      @tiles[x,y]
    else
      nil
    end
  end

  def []= x, y, value
    if @tiles.coordinates_valid? x, y
      # Disown old tile
      @tiles[x,y].board = nil
      # Add new tile
      @tiles[x,y] = value
      # Own new tile
      value.board = self
    else
      # Invalid coordinates during assignment is not ok
      raise ArgumentError.new "Invalid coordinates"
    end
  end

  def to_s
    @tiles.render " ", "\n"
  end

  def self.load_from_ascii ascii_raw
    lines = ascii_raw.remove_nth_char_from_lines(2).split("\n")
    width = lines.group_by(&:size).max.first
    height = lines.size
    Board.new(width, height).tap do |board|
      lines.each_with_index do |row_ascii, y|
        row_ascii.chars.each_with_index do |tile_ascii, x|
          board[x,y] = board.new_tile tile_ascii
        end
      end
    end
  end

  def self.load_from_file file_path
    load_from_ascii File.read(file_path)
  end

  def new_tile tile_content = nil
    Tile.new(tile_content).tap do |t|
      t.board = self
    end
  end

  def tile_coordinates tile
    @tiles.to_a_of_rows.each_with_index do |row, y|
      if x = row.index(tile)
        return [x,y]
      end
    end
    return nil
  end

  def adjacent_tile_coordinates tile, direction
    coords = Vector.elements(tile_coordinates tile)
    coords_adjacent = coords + Vector.elements(direction)
    coords_adjacent.to_a
  end

  def adjacent_tile tile, direction
    self[*adjacent_tile_coordinates(tile, direction)]
  end
end