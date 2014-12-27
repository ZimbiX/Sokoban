class Tile
  attr_accessor :inhabitants
  attr_accessor :board

  def initialize tile_content = nil
    @inhabitants = []
    objs =
      case tile_content
      when String then GAME_ASCII.key(tile_content)
      when Array then tile_content
      end
    objs && objs.each do |obj|
      Kernel.const_get(obj).new(self)
    end
  end

  # All logic for a piece arriving at a tile -- any solidity
  def place piece
    if free? or not piece.solid?
      inhabitants << piece
      inhabitants.sort_by! { |p| p.class.name }
      piece.tile = self
    end
  end

  # All logic for a solid piece leaving a tile
  def take
    unless free?
      piece = solid_inhabitant
      inhabitants.delete piece
      piece.tile = nil
      piece
    end
  end

  def solid_inhabitant
    inhabitants.find &:solid?
  end

  def free?
    !solid_inhabitant
  end

  def inhabitants_classes
    inhabitants.map &:class
  end

  def adjacent_tile direction
    board.adjacent_tile self, direction
  end

  # Attempts to recursively move/shove this tile's solid inhabitant in the given direction, and returns whether this was successful
  def move_solid_inhabitant direction, shove_power
    puts 'move_solid_inhabitant'
    if free?
      true # Nothing to move; all good for something to move into this tile
    elsif shove_power == 0
      false # There's something here, but we're out of shove power; move nothing
    else
      # Attempt to recursively move/shove in this direction
      if adjacent_tile(direction).move_solid_inhabitant(direction, shove_power-1)
        # All the pieces in this direction are now out of the way
        # Move this piece to the next tile
        piece = take
        adjacent_tile(direction).place piece
      end
    end
  end
end