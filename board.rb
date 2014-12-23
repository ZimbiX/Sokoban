class Board
  def initialize width, height
    @tiles = Matrix.new width, height
  end

  def to_s

  end

  def self.load_from_file file_path
    content = File.read(file_path).split.map { |row| row.chars.to_a }
    width = content.group_by(&:size).max.first
    height = content.size
    
  end
end