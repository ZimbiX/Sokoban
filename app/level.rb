class Level
  attr_accessor :board

  def initialize level_number
    @board = Board.load_from_file level_file(level_number)
  end

  def level_file level_number
    padded_level_number = level_number.to_s.rjust 3, '0'
    File.join File.expand_path('../../levels', __FILE__), "level-#{padded_level_number}.sokoban-level"
  end
end
