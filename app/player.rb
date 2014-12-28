class Player < Piece
  attr_accessor :shove_power

  def initialize initial_tile = nil
    @shove_power = 1
    super(initial_tile)
  end

  def move direction
    # Add shove power so the player can be moved too
    tile.move_solid_inhabitant direction, shove_power+1
  end
end