require 'require_all'
require_rel './spec_helper.rb'

describe Player do
  describe ".move" do
    it "can move the player left" do
      player = Player.new
      board = Board.new 3, 3
      tile_start = board.new_tile
      board[1,1] = tile_start
      tile_start.place player
      board[1,1].inhabitants_classes.must_equal [Player]
      board[0,1].inhabitants_classes.must_equal []
      player.move LEFT
      board[1,1].inhabitants_classes.must_equal []
      board[0,1].inhabitants_classes.must_equal [Player]
    end
  end
end