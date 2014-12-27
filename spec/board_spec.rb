require 'require_all'
require_rel './spec_helper.rb'

describe Board do
  describe "assigning and returning a tile" do
    it "works for valid coordinates" do
      board = Board.new 3, 3
      tile = Tile.new
      board[2,0] = tile
      board[2,0].must_equal tile
    end

    it "fails for invalid coordinates" do
      board = Board.new 3, 3
      invalid_coords = [
        [-1, 0],
        [ 0,-1],
        [ 3, 2],
        [ 2, 3],
      ]
      invalid_coords.each do |invalid_coord|
        board[*invalid_coord].must_equal nil
        proc { board[*invalid_coord] = '' }.must_raise ArgumentError
      end
    end
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