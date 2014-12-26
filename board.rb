require 'matrix'

class Matrix
  # Make Matrix mutable
  public :"[]=", :set_element, :set_component

  def render h_separator, v_separator
    # Transpose (swap axis) so we can iterate over rows first
    self.transpose.to_a.map { |row| row.join h_separator }.join v_separator
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
end