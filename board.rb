class Board
  def initialize width, height
    @tiles = Matrix.build(width, height) { Tile.new }
  end

  def [] x, y
    @tiles[x,y]
  end

  def to_s

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