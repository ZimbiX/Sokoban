class Tile
  def initialize tile_content = nil
    @inhabitants = []
    case tile_content
    when GAME_ASCII[:Player]
      place Player.new
    when GAME_ASCII[:Wall]
      place Wall.new
    when GAME_ASCII[:Box]
      place Box.new
    when GAME_ASCII[:Goal]
      place Goal.new
    when GAME_ASCII[:Box_on_Goal]
      place Goal.new
      place Box.new
    end
  end

  def place piece
    @inhabitants << piece
    piece.tile = self
  end

  def take piece
    @inhabitants.delete piece
    piece.tile = nil
  end

  def free?
    @inhabitants.keep_if { |x| SOLID_PIECES.include? x.class.name.to_symbol }.empty?
  end
end