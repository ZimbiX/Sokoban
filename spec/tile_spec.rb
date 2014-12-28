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
end
