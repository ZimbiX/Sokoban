class Piece
  attr_accessor :tile

  def initialize initial_tile
    # Tiles handle the placement of a piece
    initial_tile.place self
  end

  def to_s
    GAME_ASCII[self.class.name.to_sym]
  end
end