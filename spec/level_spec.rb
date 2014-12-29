require 'require_all'
require_rel './spec_helper.rb'

describe Level do
  describe ".initialize" do
    describe "when given the number of a valid level" do
      it "can create a board" do
        level = Level.new 1
        board = level.board
        board.must_be_instance_of Board
        board.width.must_equal 8
        board.height.must_equal 9
      end
    end
  end
end
