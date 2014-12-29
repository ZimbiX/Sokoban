require 'require_all'
require_rel './spec_helper.rb'

describe Board do
  describe ".new" do
    it "assigns the board to the new tiles" do
      board = Board.new 1, 1
      board[0,0].board.must_equal board
    end
  end

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

    it "updates tile ownership" do
      board = Board.new 2, 2
      tile_old = board[0,0]
      tile_new = Tile.new
      tile_old.board.must_equal board
      tile_new.board.must_equal nil
      board[0,0] = tile_new
      tile_old.board.must_equal nil
      tile_new.board.must_equal board
    end
  end

  describe ".tile_coordinates" do
    it "returns the coordinates of a tile" do
      board = Board.new 3, 3
      coords = [2,1]
      tile = board[*coords]
      board.tile_coordinates(tile).must_equal coords
    end

    it "returns the coordinates of a newly-assigned tile" do
      board = Board.new 3, 3
      coords = [2,1]
      [Tile.new, board.new_tile].each do |tile|
        board[*coords] = tile
        board.tile_coordinates(tile).must_equal coords
      end
    end

    it "returns nil when the tile is not in the board" do
      board = Board.new 3, 3
      tile = Tile.new
      board.tile_coordinates(tile).must_equal nil
    end
  end

  describe ".adjacent_tile" do
    it "works when given a valid tile and direction" do
      board = Board.new 3, 3
      tile_start = board[1,1]
      board.adjacent_tile(tile_start, LEFT ).must_equal board[0,1]
      board.adjacent_tile(tile_start, [0,1]).must_equal board[1,2]
    end
  end

  describe ".new_tile" do
    it "returns a new tile with the board assigned" do
      board = Board.new 2, 2
      tile = board.new_tile
      tile.must_be_instance_of Tile
      tile.board.must_equal board
      Tile.new.board.must_equal nil
    end
  end

  describe ".load_from_ascii" do
    it "creates a board such that its I/O is the same" do
      level_ascii =
<<-END
    # # # # #
# # #       #
# - $ 0     #
# # #   0 - #
# - # # 0   #
#   #   -   #
# 0   8 0 0 - #
#       -     #
# # # # # # # #
END
      board = Board.load_from_ascii level_ascii
      board.width.must_equal 8
      board.height.must_equal 9
      board.to_s.must_equal level_ascii.lines.to_a.map(&:rstrip)
    end
  end
end
