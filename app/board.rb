require 'matrix'

class Matrix
  # Make Matrix mutable
  public :"[]=", :set_element, :set_component

  def to_a_of_rows
    # Transpose (swap axis) so we are given an array of rows rather than an array of columns
    self.transpose.to_a
  end

  def render h_separator, v_separator
    self.to_a_of_rows.map { |row| row.join h_separator }.join v_separator
  end
end

class Board
  def initialize width, height
    # Argument order is y,x: Matrix.build(rows, columns)
    @tiles = Matrix.build(height, width) { Tile.new }
  end

  def [] x, y
    @tiles[x,y]
  end

  def []= x, y, value
    @tiles[x,y] = value
  end

  def to_s
    @tiles.render " ", "\n"
  end

  def self.load_from_file file_path
    content = File.read(file_path).split.map { |row| row.chars.to_a }
    width = content.group_by(&:size).max.first
    height = content.size
    board = Board.new width, height
    content.each_with_index do |row_content, y|
      row_content.each_with_index do |tile_content, x|
        board[x,y] = Tile.new tile_content
      end
    end
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

  def adjacent_tile tile, direction

  end
end