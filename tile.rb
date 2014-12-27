class Tile
  attr_accessor :inhabitants

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

  # All logic for a piece arriving at a tile
  def place piece
    @inhabitants << piece
    @inhabitants.sort_by! { |p| p.to_s }
    piece.tile = self
  end

  # All logic for a piece leaving a tile
  def take piece
    @inhabitants.delete piece
    piece.tile = nil
  end

  def free?
    @inhabitants.keep_if { |x| SOLID_PIECES.include? x.class.name.to_symbol }.empty?
  end
end