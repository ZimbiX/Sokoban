require 'require_all'
require_rel './spec_helper.rb'

describe Player do
  describe ".move" do
    it "can move the player one tile in any direction" do
      player = Player.new
      board = Board.new 2, 2
      tile_start = board.new_tile
      board[0,0] = tile_start
      tile_start.place player
      player.tile.must_equal tile_start
      [RIGHT, DOWN, LEFT, UP].each do |direction|
        coords_old = board.tile_coordinates player.tile
        coords_new = board.tile_coordinates player.tile.adjacent_tile(direction)
        [coords_old, coords_new].each do |coords|
          coords.must_be_instance_of Array
          coords.length.must_equal 2
        end
        coords_new.must_be_instance_of Array
        board[*coords_old].inhabitants_classes.must_equal [Player]
        board[*coords_new].inhabitants_classes.must_equal []
        player.move direction
        board[*coords_old].inhabitants_classes.must_equal []
        board[*coords_new].inhabitants_classes.must_equal [Player]
      end
    end
  end
end