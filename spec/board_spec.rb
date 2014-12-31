require 'require_all'
require_rel './spec_helper.rb'

describe Board do
  describe Matrix do
    it "Creates a Matrix with the axis corrected" do
      matrix = Matrix.build(1, 3) { nil }
      matrix.width.must_equal 1
      matrix.height.must_equal 3
    end

    it "can return an array of rows" do
      matrix = Matrix.build(1, 3) { nil }
      matrix.to_a_of_rows.size.must_equal 3
    end
  end

  describe ".new" do
    it "assigns the board to the new tiles" do
      board = Board.new 1, 1
      board[0,0].board.must_equal board
    end
  end

  it "gets the width and height correct" do
    board = Board.new 1, 5
    board.width.must_equal 1
    board.height.must_equal 5
    board[0,4].wont_equal nil
    board[0,5].must_equal nil
    board[1,0].must_equal nil
    tile = Tile.new
    board[0,4] = tile
    board[0,4].must_equal tile
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

  let(:level_ascii) {
    ascii = <<-END
    # # # # #
# # #       #
# - $ 0     #
# # #   0 - #
# - # # 0   #
#   #   -   # #
# 0   8 0 0 - #
#       -     #
# # # # # # # #
END
    ascii.chomp
  }

  describe ".load_from_ascii" do
    it "creates a board such that its I/O is the same" do
      board = Board.load_from_ascii level_ascii
      board.width.must_equal 8
      board.height.must_equal 9
      board.to_s.lines.to_a.map(&:rstrip).join("\n").must_equal level_ascii
    end
  end

  it "can find its player piece" do
    board = Board.new 1, 1
    board[0,0] = Tile.new GAME_ASCII[[:Player]]
    board[0,0].solid_inhabitant.must_be_instance_of Player
    board.player.must_be_instance_of Player

    board = Board.load_from_ascii GAME_ASCII[[:Player]]
    board[0,0].solid_inhabitant.must_be_instance_of Player
    board.player.must_be_instance_of Player
  end

  it "can shove a box in a level" do
    board = Board.load_from_ascii level_ascii
    player = board.player
    player.must_be_instance_of Player
    box = player.tile.adjacent_tile(RIGHT).solid_inhabitant
    box.must_be_instance_of Box
    coords_start_player = Vector.elements player.coords
    coords_start_box = Vector.elements box.coords
    coords_delta_right = Vector.elements RIGHT
    player.move RIGHT
    coords_end_player = player.coords
    coords_end_box = box.coords
    coords_end_player.must_equal (coords_start_player + coords_delta_right).to_a
    coords_end_box.must_equal    (coords_start_box    + coords_delta_right).to_a
  end
end
