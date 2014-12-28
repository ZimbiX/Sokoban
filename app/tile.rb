class Tile
  attr_accessor :inhabitants
  attr_accessor :board

  def initialize *tile_content_args
    @inhabitants = []
    tile_content = tile_content_args.compact # Remove nils

    # Existing pieces to add to this tile
    pieces = tile_content.select { |x| x.is_a? Piece }
    # A game ASCII character to be converted to the list of piece class types to create
    ascii = tile_content.select { |x| x.is_a? String }
    # Piece class types to create
    classes = tile_content - ascii - pieces

    # Add the existing pieces to this tile
    pieces.each { |p| place p }

    # Add to the existing list of piece class types to create
    classes += ascii.map { |char| GAME_ASCII.key char }.flatten

    # Create the pieces from the list of classes, with each adding itself to this tile
    classes.each do |klass|
      Kernel.const_get(klass).new self
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

  def inhabitants_classes_symbols
    inhabitants_classes.map { |c| c.name.to_sym }
  end

  def adjacent_tile direction
    if board
      board.adjacent_tile self, direction
    else
      raise TypeError.new "Tile has no board"
    end
  end

  # Attempts to recursively move/shove this tile's solid inhabitant in the given direction, and returns whether this was successful
  def move_solid_inhabitant direction, shove_power
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
        # Moving succeeded from the bottom up
        true
      else
        # Moving something failed; nothing was moved
        false
      end
    end
  end

  def to_s
    GAME_ASCII[inhabitants_classes_symbols]
  end
end