require 'require_all'
require_rel './spec_helper.rb'

describe Board do
  it "can assign and return a tile" do
    board = Board.new 3, 3
    tile = Tile.new
    board[2,0] = tile
    board[2,0].must_equal tile
  end

  describe ".tile_coordinates" do
    it "returns the coordinates of a tile" do
      board = Board.new 3, 3
      coords = [2,1]
      tile = board[*coords]
      board.tile_coordinates(tile).must_equal coords
    end

    it "returns nil when the tile is not in the board" do
      board = Board.new 3, 3
      tile = Tile.new
      board.tile_coordinates(tile).must_equal nil
    end
  end
end