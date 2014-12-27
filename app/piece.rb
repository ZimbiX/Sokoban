class Piece
  attr_accessor :tile

  def initialize initial_tile = nil
    # Tiles handle the placement of a piece
    initial_tile && initial_tile.place(self)
  end

  def solid?
    SOLID_PIECES.include? self.class.name.to_sym
  end

  def to_s
    GAME_ASCII[self.class.name.to_sym]
  end
end