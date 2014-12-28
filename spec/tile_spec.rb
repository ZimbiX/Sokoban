require 'require_all'
require_rel './spec_helper.rb'

describe Tile do
  describe ".initialize" do
    it "creates inhabitants from char" do
      tile = Tile.new '$'
      tile.inhabitants_classes.must_equal [Player]
    end

    it "creates inhabitants from class symbol array" do
      tile = Tile.new :Box, :Goal
      tile.inhabitants_classes.must_equal [Box, Goal]
    end

    it "adds existing pieces as inhabitants" do
      box = Box.new
      goal = Goal.new
      tile = Tile.new goal, box
      tile.inhabitants_classes.must_equal [Box, Goal]
    end

    it "can create/add mixed inhabitant types as specified" do
      tile = Tile.new Box.new, :Goal
      tile.inhabitants_classes.must_equal [Box, Goal]
      tile = Tile.new :Goal, '$'
      tile.inhabitants_classes.must_equal [Goal, Player]
    end
  end

  describe ".place" do
    let(:tile) do
      Tile.new(:Goal).tap { |tile| Box.new tile }
    end

    it "can add a second inhabitant" do
      tile.inhabitants.count.must_equal 2
    end

    it "sorts inhabitants after adding a new one" do
      tile.inhabitants_classes.must_equal [Box, Goal]
    end
  end

  describe ".take" do
    it "can remove a piece from the tile" do
      [Box, Player].each do |piece_class|
        tile = Tile.new
        piece = piece_class.new tile
        tile.inhabitants_classes.must_equal [piece_class]
        tile.take.must_equal piece
        tile.inhabitants_classes.must_equal []
      end
    end
  end

  describe ".adjacent_tile" do
    describe "when there is no board" do
      it "raises a TypeError" do
        tile = Tile.new
        proc { tile.adjacent_tile(RIGHT) }.must_raise TypeError
      end
    end

    describe "when there is a board" do
      it "returns the adjacent tile when it exists" do
        board = Board.new 3, 3
        tile = board.new_tile
        board[1,1] = tile
        {
          [1,0] => UP,
          [1,2] => DOWN,
          [2,1] => RIGHT,
          [0,1] => LEFT,
        }.each do |coords, direction|
          tile.adjacent_tile(direction).must_equal board[*coords]
        end
      end

      it "return nil when there is no tile in the given direction" do
        board = Board.new 1, 1
        tile = board.new_tile
        board[0,0] = tile
        [UP, DOWN, RIGHT, LEFT].each do |direction|
          tile.adjacent_tile(direction).must_equal nil
        end
      end
    end
  end

  describe ".move_solid_inhabitant" do
    let(:row_tri_inhabitants) do
      # Wrapped in another proc to avoid result caching
      proc do |board|
        [
          board[0,0],
          board[1,0],
          board[2,0],
        ].map &:solid_inhabitant
      end
    end

    describe "without a player" do
      it "can move a box" do
        board = Board.new 3, 3
        box = Box.new board[0,0]
        row_tri_inhabitants.call(board).must_equal [box, nil, nil]
        move_success = board[0,0].move_solid_inhabitant RIGHT, 1
        move_success.must_equal true
        row_tri_inhabitants.call(board).must_equal [nil, box, nil]
      end

      it "can't move two boxes with a shove power of 1" do
        board = Board.new 3, 3
        box1 = Box.new board[0,0]
        box2 = Box.new board[1,0]
        row_tri_inhabitants.call(board).must_equal [box1, box2, nil]
        move_success = board[0,0].move_solid_inhabitant RIGHT, 1
        move_success.must_equal false
        row_tri_inhabitants.call(board).must_equal [box1, box2, nil]
      end

      it "can move two boxes with a shove power of 2" do
        board = Board.new 3, 3
        box1 = Box.new board[0,0]
        box2 = Box.new board[1,0]
        row_tri_inhabitants.call(board).must_equal [box1, box2, nil]
        move_success = board[0,0].move_solid_inhabitant RIGHT, 2
        move_success.must_equal true
        row_tri_inhabitants.call(board).must_equal [nil, box1, box2]
      end
    end

    describe "with a player" do
      it "can move the player and a box when the path is clear" do
        board = Board.new 3, 3
        player = Player.new
        board[0,0] = Tile.new player
        box = Box.new
        board[1,0].place box
        row_tri_inhabitants.call(board).must_equal [player, box, nil]
        move_success = player.move RIGHT
        move_success.must_equal true
        row_tri_inhabitants.call(board).must_equal [nil, player, box]
      end
    end
  end
end
